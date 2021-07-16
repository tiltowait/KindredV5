//
//  ButtonPad.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI

struct ButtonPad: View {
  
  @Binding var selection: [String]
  let columns: [[String]]
  let perform: (String) -> Void
  
  var body: some View {
    HStack(alignment: .top, spacing: 5) {
      ForEach(columns, id: \.self) { column in
        VStack(spacing: 8) {
          ForEach(column, id: \.self) { row in
            ToggleButton(
              isToggled: .constant(selection.contains(row)),
              label: row,
              perform: perform
            )
          }
        }
      }
    }
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
