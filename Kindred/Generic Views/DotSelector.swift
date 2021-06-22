//
//  DotSelector.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import SwiftUI

struct DotSelector: View {
  
  @Binding var current: Int16
  let min: Int16
  let max: Int16
  
  let size: CGFloat = 17
  let spacing: CGFloat = 5
  
  var body: some View {
    HStack {
      ForEach(1...Int(max)) { index in
        Circle()
          .fill(color(for: index))
          .frame(width: size, height: size)
          .onTapGesture {
            current = Int16(index)
          }
        
        // Make a gap every 5 dots for legibility purposes
        if index > 0 && index % 5 == 0 {
          Circle().fill(Color.clear)
            .frame(width: 1, height: 1)
        }
      }
    }
  }
  
  /// Determine the color for a dot at a given rating.
  ///
  /// If `rating` is greater than the receiver's current value, then the dot is an "unfilled" color.
  /// Otherwise, it will receive a "filled" color.
  /// - Parameter rating: The index of the dot in question.
  /// - Returns: The color the dot should take.
  func color(for rating: Int) -> Color {
    rating <= current ? .vampireRed : .tertiarySystemGroupedBackground
  }
  
}

struct DotSelector_Previews: PreviewProvider {
  static var previews: some View {
    DotSelector(current: .constant(3), min: 1, max: 5)
  }
}
