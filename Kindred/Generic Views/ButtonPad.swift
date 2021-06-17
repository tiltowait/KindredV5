//
//  ButtonPad.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI

struct ButtonPad: View {
  
  let columns: [[String]]
  let perform: (String) -> Void
  
  var body: some View {
    HStack(spacing: 5) {
      ForEach(columns, id: \.self) { column in
        VStack(spacing: 5) {
          ForEach(column, id: \.self) { row in
            ToggleButton(label: row, perform: perform)
          }
        }
      }
    }
    .padding(.horizontal)
  }
  
}

struct ButtonPad_Previews: PreviewProvider {

  static let column1 = ["One", "Two", "Three"]
  static let column2 = ["Four", "Five", "Six"]
  static let column3 = ["Seven", "Eight", "Nine"]

  static var previews: some View {
    ButtonPad(columns: [column1, column2, column3]) { _ in }
  }
}
