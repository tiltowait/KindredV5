//
//  ButtonStyles.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import SwiftUI

struct PopUpTextButtonStyle: ButtonStyle {
  
  @Environment(\.colorScheme) var colorScheme
  
  let height: CGFloat = 40
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(size: height * 0.5, weight: .bold))
      .font(Font.body.weight(.bold))
      .padding(.horizontal)
      .frame(height: height)
      .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
      .background(
        RoundedRectangle(cornerRadius: 1000)
          .fill(Color(white: colorScheme == .dark ? 0.19 : 0.93))
          .shadow(radius: 2)
      )
  }
}

struct PopUpImageButtonStyle: ButtonStyle {
  @Environment(\.colorScheme) var colorScheme

  let size: CGFloat = 40
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(size: size * 0.5, weight: .bold))
      .frame(width: size, height: size)
      .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
      .background(
        Circle()
          .fill(Color(white: colorScheme == .dark ? 0.19 : 0.93))
          .shadow(radius: 2)
      )
  }
}
