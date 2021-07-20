//
//  MoralityTrack.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/20/21.
//

import SwiftUI
import CoreHaptics

struct MoralityTrack: View {
  
  @Environment(\.viewController) var viewController
  
  @StateObject var viewModel: ViewModel
  @State private var engine = try? CHHapticEngine()
  
  let size: CGFloat = 17
  let spacing: CGFloat = 5
  
  init(kindred: Kindred) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var button: some View {
    Group {
      if viewModel.allowDegen {
        Button("Degen", action: degen)
      } else {
        Button("Remorse", action: remorseCheck)
          .disabled(!viewModel.allowRemorse)
      }
    }
    .font(.callout)
    .accentColor(.vampireRed)
    .buttonStyle(BorderlessButtonStyle())
  }
  
  var body: some View {
    VStack {
      Text("Humanity")
        .font(.subheadline)
        .bold()
      
      HStack(spacing: spacing) {
        ForEach(viewModel.track.indices, id: \.self) { index in
          dot(code: viewModel.track[index])
            .onTapGesture {
              promote(index: index)
            }
          if index == 4 {
            // Add some empty padding
            Color.clear.frame(width: 1, height: 1)
          }
        }
      }
      button
        .padding(.top, 5)
    }
    .centered()
  }
  
  func promote(index: Int) {
    let promoted = withAnimation(.easeInOut(duration: 0.12)) {
      viewModel.promote(index: index)
    }
    
    if promoted {
      Global.hapticTap(engine: engine)
    }
  }
  
  func degen() {
    withAnimation {
      viewModel.degen()
    }
    
    Global.hapticTap(engine: engine)
  }
  
  func remorseCheck() {
    let showedRemorse = withAnimation {
      viewModel.remorseCheck()
    }
    
    let popoverTitle: String
    let popoverContents: String
    
    if showedRemorse {
      popoverTitle = "Remorseful"
      popoverContents = "Your Humanity is intact."
      UINotificationFeedbackGenerator().notificationOccurred(.success)
    } else {
      popoverTitle = "No Remorse"
      popoverContents = "Your Best gains sway."
      UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    viewController?.present {
      Popover {
        VStack(spacing: 10) {
          Text(popoverTitle)
            .font(.title2)
            .bold()
          Text(popoverContents)
            .lineLimit(2)
        }
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      viewController?.dismiss(animated: true)
    }
  }
  
  func dot(code: Character) -> some View {
    ZStack {
      Circle()
        .fill(fillColor(code: code))
      Circle()
        .strokeBorder(strokeColor(code: code), lineWidth: 2)
    }
    .frame(width: size, height: size)
  }
  
  func fillColor(code: Character) -> Color {
    switch code {
    case "o": return Color.vampireRed
    case "/": return Color.purple
    case "x": return Color.white
    default: return Color.tertiarySystemGroupedBackground
    }
  }
  
  func strokeColor(code: Character) -> Color {
    switch code {
    case "o": return Color.vampireRed
    case "/": return Color.purple
    case "x": return Color.red
    default: return Color.tertiarySystemGroupedBackground
    }
  }
  
}

#if DEBUG
struct MoralityTracker_Previews: PreviewProvider {
  static var previews: some View {
    List {
      MoralityTrack(kindred: Kindred.example)
    }
    .listStyle(InsetGroupedListStyle())
  }
}
#endif
