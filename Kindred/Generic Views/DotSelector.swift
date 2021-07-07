//
//  DotSelector.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import SwiftUI
import CoreHaptics

struct DotSelector: View {
  
  @State private var engine = try? CHHapticEngine()
  
  @Binding var current: Int16
  let min: Int16
  let max: Int16
  let allowZero: Bool
  
  let size: CGFloat = 17
  let spacing: CGFloat = 5
  
  /// Create a new DotSelector.
  /// - Parameters:
  ///   - current: The binding to the current dot rating.
  ///   - min: The minimum number of dots.
  ///   - max: The maximum number of dots.
  ///   - allowZero: Whether zero dots are allowed.
  init(current: Binding<Int16>, min: Int16, max: Int16, allowZero: Bool = true) {
    _current = current
    self.min = min
    self.max = max
    self.allowZero = allowZero
  }
  
  var body: some View {
    HStack {
      ForEach(Int(min)...Int(max)) { index in
        // Make a gap every 5 dots for legibility purposes
        if index > 0 && (index - 1) % 5 == 0 {
          Color.clear.frame(width: 1, height: 1)
        }
        
        shape(for: index)
          .onTapGesture {
            select(dots: index)
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
  
  /// Create a square for negative indices and a circle for positive.
  ///
  /// The shape is automatically sized and filled with the appropriate color.
  /// - Parameter index: The shape's index.
  /// - Returns: The generated shape.
  @ViewBuilder func shape(for index: Int) -> some View {
    if index < 0 {
      Rectangle()
        .fill(color(for: index))
        .frame(width: size, height: size)
    } else {
      Circle()
        .fill(color(for: index))
        .frame(width: size, height: size)
    }
  }
  
  /// Select the given number of dots. If "one" is double-tapped, set to 0.
  /// - Parameter dots: The number of dots to select.
  func select(dots: Int) {
    // Normally, if the user taps a dot, we simply select it; however,
    // there are some considerations for tapping an already-selected
    // dot.
    //
    // 1. Smallest magnitude dot - do we allow zero?
    // 2. Ranges can be negative. Do we increment or decrement?
    //
    // We also want to use the correct haptic tap—sharp or error.
    
    if dots != current {
      current = Int16(dots)
      Global.hapticTap(engine: engine)
    } else {
      if current == 1 {
        if allowZero {
          current = 0
          Global.hapticTap(engine: engine)
        } else {
          // Don't allow the selection
          UINotificationFeedbackGenerator().notificationOccurred(.warning)
        }
      } else {
        current += current < 0 ? 1 : -1 // bring closer to 0
        Global.hapticTap(engine: engine)
      }
    }
  }
  
}

struct DotSelector_Previews: PreviewProvider {
  static var previews: some View {
    DotSelector(current: .constant(3), min: 1, max: 11)
  }
}
