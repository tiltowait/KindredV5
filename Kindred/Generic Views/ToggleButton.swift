//
//  ToggleButton.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI

struct ToggleButton: View {
  
  @State private var isToggled = false
  let onColor = Color.red
  let offColor = Color.secondary
  
  let label: String
  let perform: (String) -> Void
  
  var body: some View {
    Button {
      isToggled.toggle()
      perform(label)
    } label: {
      Spacer()
      Text(label)
        .font(.callout)
        .bold()
      Spacer()
    }
    .padding(.vertical, 5)
    .background(isToggled ? onColor : offColor)
    .foregroundColor(.white)
    .cornerRadius(10)
  }
}

struct ToggleButton_Previews: PreviewProvider {
  static var previews: some View {
    ToggleButton(label: "Animal Ken") { _ in }
      .previewLayout(.sizeThatFits)
  }
}
