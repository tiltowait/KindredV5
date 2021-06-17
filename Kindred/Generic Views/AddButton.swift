//
//  AddButton.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct AddButton: View {
  @Environment(\.colorScheme) var colorScheme
  
  let height: CGFloat
  
  init(_ height: CGFloat = 24) {
    self.height = height
  }
  
  var body: some View {
    Text("Add")
      .font(.system(size: height * 0.5, weight: .bold))
      .font(Font.body.weight(.bold))
//      .font(.system(size: height * 2))
      .padding(.horizontal)
      .frame(height: height)
      .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
      .background(
        RoundedRectangle(cornerRadius: 100)
          .fill(Color(white: colorScheme == .dark ? 0.19 : 0.93)
          )
      )
  }
}

struct AddButton_Previews: PreviewProvider {
  static var previews: some View {
    HStack {
      ExitButton(40)
      AddButton(40)
    }
  }
}
