//
//  ExitButton.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct ExitButton: View {
  @Environment(\.colorScheme) var colorScheme
  
  let size: CGFloat
  
  init(_ size: CGFloat = 40) {
    self.size = size
  }
  
  var body: some View {
    ZStack {
      Circle()
        .fill(Color(white: colorScheme == .dark ? 0.19 : 0.93))
      Image(systemName: "xmark")
        .resizable()
        .scaledToFit()
        .font(Font.body.weight(.bold))
        .scaleEffect(0.416)
        .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
    }
    .frame(width: size, height: size)
  }
}

struct ExitButton_Previews: PreviewProvider {
  static var previews: some View {
    ExitButton()
  }
}
