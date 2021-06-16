//
//  BoldTextField.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/16/21.
//

import SwiftUI

struct BoldTextField: View {
  
  let label: String
  @Binding var value: String
  
  init(_ label: String, value: Binding<String>) {
    self.label = label
    _value = value
  }
  
  var body: some View {
    HStack {
      Text("\(label):")
        .bold()
      TextField("No \(label.lowercased()) set", text: $value)
    }
  }
}

struct BoldTextField_Previews: PreviewProvider {
  static var previews: some View {
    BoldTextField("Sire", value: .constant("Vivette de Klerk"))
  }
}
