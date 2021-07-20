//
//  Trackers.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/23/21.
//

import SwiftUI

struct Trackers: View {
  
  @Environment(\.viewController) var viewController
  
  @StateObject var viewModel: ViewModel
  
  @State private var showingEditView = false
  
  init(kindred: Kindred) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var headerButton: some View {
    Button {
      withAnimation {
        showingEditView.toggle()
      }
    } label: {
      if showingEditView {
        Text("Done")
      } else {
        Text("Edit")
      }
    }
  }
  
  var header: some View {
    HStack {
      Text("Trackers")
      Spacer()
      headerButton
    }
  }
  
  var footer: some View {
    Group {
      if viewModel.kindred.clan == nil {
        Text("Missing Blood Potency and Hunger? Don't forget to set your clan!")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
  }
  
  var trackerDetailView: some View {
    VStack {
      StressTrack("Health", track: $viewModel.kindred.healthString)
        .padding(.bottom, 5)
        .centered()
      Divider()
      StressTrack("Willpower", track: $viewModel.kindred.willpowerString)
        .padding(.bottom, 5)
        .centered()
      Divider()
      MoralityTrack(kindred: viewModel.kindred)
      
      if viewModel.kindred.clan?.template == .kindred {
        Divider()
        tracker("Blood Potency", rating: viewModel.kindred.bloodPotency, max: 10)
        Divider()
        VStack {
          Text("Hunger")
            .bold()
          ZStack {
            DotSelector(current: $viewModel.kindred.hunger, min: 0, max: 5)
            HStack {
              Spacer()
              Button("Rouse", action: rouse)
                .font(.callout)
                .accentColor(.vampireRed)
                .disabled(!viewModel.canRouse)
                .buttonStyle(BorderlessButtonStyle())
            }
          }
        }
        .id(viewModel.kindred.hunger) // Force redraw on change
        .padding(.bottom, 5)
      }
    }
  }
  
  var trackerModifierView: some View {
    VStack {
      Text("Modify Trackers")
        .font(.headline)
      Divider()
      TrackerStepper(
        "Health:",
        value: $viewModel.kindred.health,
        in: 4...15, onIncrement:
          viewModel.incrementHealth,
        onDecrement: viewModel.decrementHealth
      )
      Divider()
      TrackerStepper(
        "Willpower:",
        value: $viewModel.kindred.willpower,
        in: 3...15,
        onIncrement: viewModel.incrementWillpower,
        onDecrement: viewModel.decrementWillpower
      )
      Divider()
      TrackerStepper(
        "Humanity:",
        value: $viewModel.kindred.humanity,
        in: 0...10
      )
      
      if viewModel.kindred.clan?.template == .kindred {
        Divider()
        TrackerStepper(
          "Blood Potency:",
          value: $viewModel.kindred.bloodPotency,
          in: 0...10
        )
        Divider()
        TrackerStepper(
          "Hunger:",
          value: $viewModel.kindred.hunger,
          in: 0...5
        )
      }
    }
  }
  
  var swapHeight: CGFloat {
    viewModel.kindred.clan?.template == .kindred ? 360 : 230
  }
  
  var body: some View {
    Section(header: header, footer: footer) {
      SwapView(
        showingLeft: !showingEditView,
        height: swapHeight
      ) {
        trackerDetailView
      } right: {
        trackerModifierView
      }
    }
  }
  
  /// Create a tracker display for a given trait.
  /// - Parameters:
  ///   - label: The name of the trait.
  ///   - rating: The trait's current rating.
  ///   - max: The maximum possible value of that trait.
  /// - Returns: The tracker's display.
  func tracker(_ label: LocalizedStringKey, rating: Int16, max: Int) -> some View {
    VStack {
      Text(label)
        .bold()
      DotView(rating: rating, max: max)
    }
    .padding(.bottom, 5)
  }
  
  func rouse() {
    let rouseResult = viewModel.rouseCheck()
    
    if rouseResult {
      UINotificationFeedbackGenerator().notificationOccurred(.success)
    } else {
      UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    viewController?.present {
      RouseResult(successful: rouseResult)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      viewController?.dismiss(animated: true)
    }
  }
  
}

#if DEBUG
struct Trackers_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        Trackers(kindred: Kindred.example)
      }
      .listStyle(InsetGroupedListStyle())
    }
  }
}
#endif
