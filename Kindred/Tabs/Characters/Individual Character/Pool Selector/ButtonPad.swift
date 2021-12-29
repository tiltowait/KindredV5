//
//  ButtonPad.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI
import CoreHaptics

struct ButtonPad: View {
  
  @State private var engine = try? CHHapticEngine()
  
  @Binding var selection: [String]
  let columns: [[String]]
  let perform: (String) -> Void
  
  var body: some View {
    HStack(alignment: .top, spacing: 5) {
      ForEach(columns, id: \.self) { column in
        VStack(spacing: 8) {
          ForEach(column, id: \.self) { row in
            Button {
              performHandler(row)
            } label: {
              HStack {
                Spacer()
                Text(row)
                  .font(.callout)
                Spacer()
              }
            }
            .buttonStyle(
              ToggleButton(
                isToggled: .constant(selection.contains(row)),
                color: .red
              )
            )
            .accessibilityHint("Add \(row) to pool")
          }
        }
      }
    }
  }
  
  func performHandler(_ string: String) {
    Global.hapticTap(engine: engine)
    perform(string)
  }
  
}

struct ButtonPad_Previews: PreviewProvider {

  static let column1 = ["One", "Two", "Three"]
  static let column2 = ["Four", "Five", "Six"]
  static let column3 = ["Seven", "Eight", "Nine"]

  static var previews: some View {
    ButtonPad(selection: .constant([]), columns: [column1, column2, column3]) { _ in }
  }
}
