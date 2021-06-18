//
//  CenteredModifier.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import SwiftUI

/// A view modifier that centers its content horizontally.
struct Centered: ViewModifier {
  
  func body(content: Content) -> some View {
    HStack {
      Spacer()
      content
      Spacer()
    }
  }
  
}

extension View {
  
  /// Center the content horizontally.
  /// - Returns: The centered content.
  func centered() -> some View {
    self.modifier(Centered())
  }
  
}
