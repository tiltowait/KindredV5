//
//  StressTrack.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import SwiftUI
import CoreHaptics

struct StressTrack: View {
  
  @State private var engine = try? CHHapticEngine()
  
  let label: LocalizedStringKey
  @Binding var track: String
  
  init(_ label: LocalizedStringKey, track: Binding<String>) {
    self.label = label
    _track = track
  }
  
  var gap: some View {
    Circle()
      .fill(Color.clear)
      .frame(width: 1, height: 1)
  }
  
  var body: some View {
    VStack {
      Text(label)
        .font(.subheadline)
        .bold()
      
      HStack {
        ForEach(Array(track).indices, id: \.self) { index in
          StressBox(code: Array(track)[index])
            .onTapGesture {
              promote(at: index)
            }
          if (index + 1) % 5 == 0 {
            gap
          }
        }
      }
    }
  }
  
  func promote(at index: Int) {
    let current = Array(track)[index]
    
    switch current {
    case "/":
      track.replace(index, with: "x")
    case "x":
      track.replace(index, with: ".")
    default:
      track.replace(index, with: "/")
    }
    Global.hapticTap(engine: engine)
  }
  
}

struct StressTrack_Previews: PreviewProvider {
  static var previews: some View {
    StressTrack("Health", track: .constant("....../x"))
  }
}
