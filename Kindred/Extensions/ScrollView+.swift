//
//  ScrollView+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/15/21.
//

import SwiftUI

extension ScrollView {
  
  /// Fade the horizontal edges of the scroll view.
  ///
  /// It would be a good idea to pad the leading portion of your content.
  ///
  /// User interaction on faded portions is not possible. Use with care.
  /// - Parameter width: The width of the fade.
  /// - Returns: The modified `ScrollView`.
  func fadeHorizontalEdges(width: CGFloat = 10) -> some View {
    ZStack {
      self
      
      HStack {
        LinearGradient(
          gradient: Gradient(
            stops: [
              .init(color: .systemBackground, location: 0),
              .init(color: .systemBackground.opacity(0.01), location: 1)
            ]
          ),
          startPoint: .leading,
          endPoint: .trailing
        )
        .frame(width: 10)
        Spacer()
        LinearGradient(
          gradient: Gradient(
            stops: [
              .init(color: .systemBackground.opacity(0.01), location: 0),
              .init(color: .systemBackground, location: 1)
            ]
          ),
          startPoint: .leading,
          endPoint: .trailing
        )
        .frame(width: 10)
      }
    }
  }
  
}
