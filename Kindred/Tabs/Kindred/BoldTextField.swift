//
//  BoldTextField.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/16/21.
//

import SwiftUI

/// A text field with a bold label to its left.
struct BoldTextField: View {
  
  let label: String
  @Binding var binding: String
  
  /// Create a bold text field.
  ///
  /// The view automatically adds a colon at the end of the label.
  /// - Parameters:
  ///   - label: The text of the label.
  ///   - value: The associated binding.
  init(_ label: String, binding: Binding<String>) {
    self.label = label
    _binding = binding
  }
  
  var body: some View {
    HStack {
      Text("\(label):")
        .bold()
      TextField("No \(label.lowercased()) set", text: $binding)
    }
  }
}

struct BoldTextField_Previews: PreviewProvider {
  static var previews: some View {
    BoldTextField("Sire", binding: .constant("Vivette de Klerk"))
  }
}
