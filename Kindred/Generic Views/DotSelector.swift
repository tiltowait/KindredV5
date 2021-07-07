//
//  DotSelector.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import SwiftUI
import CoreHaptics

struct DotSelector: View {
    
  // User-supplied
  @Binding var currentValue: Int16
  let min: Int16
  let max: Int16
  
  // Derived
  private let allowZero: Bool
  private var negativeSelection: Bool
  @State private var currentValueProxy: Int16
  
  // Haptics
  @State private var engine = try? CHHapticEngine()

  
  let size: CGFloat = 17
  let spacing: CGFloat = 5
  
  /// Create a new DotSelector.
  ///
  /// The minimum and maximum ratings must have the same sign.
  /// - Parameters:
  ///   - current: The binding to the current dot rating.
  ///   - min: The minimum number of dots.
  ///   - max: The maximum number of dots.
  init(current: Binding<Int16>, min: Int16, max: Int16) {
    assert((min <= 0 && max <= 0) || (min >= 0 && max >= 0), "Minimum and maximum values must have a matching sign.")
    
    _currentValue = current
    
    // Figure out if we're allowing a rating of zero. If we are, we
    // want to change min to +/- 1 so that we don't draw an extra
    // box or circle.
    
    var min = min
    if min == 0 {
      allowZero = true
      min = max < 0 ? -1 : 1 // Make sure signs match
    } else {
      allowZero = false
    }
    
    // Trait ranges can be either positive or negative (but cannot be
    // both). If a trait is negative, its range is something like
    // -3...-1. If we were to draw the boxes based on currentValue
    // directly, then we would wind up with a bug. A current value
    // of -1 would lead to all boxes being filled rather than just
    // one. If we get slightly more clever and use absolute values
    // for determining box color, we wind up with a single box filled
    // ... but right-aligned rather than left.
    //
    // The solution is to wrap up the value in a proxy and make the
    // ranges always be positive. Then, when the proxy's value
    // changes, we simply assign the proxy's value to the receiver,
    // flipping the sign if necessary.
    
    if min < 0 && max < 0 {
      negativeSelection = true
      self.min = -max
      self.max = -min
      _currentValueProxy = State(wrappedValue: -current.wrappedValue)
    } else {
      negativeSelection = false
      self.min = min
      self.max = max
      _currentValueProxy = State(wrappedValue: current.wrappedValue)
    }
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
    .onChange(of: currentValueProxy, perform: updateReceiver)
  }
  
  /// Determine the color for a dot at a given rating.
  ///
  /// If `rating` is greater than the receiver's current value, then the dot is an
  /// "unfilled" color. Otherwise, it will receive a "filled" color.
  /// - Parameter rating: The index of the dot in question.
  /// - Returns: The color the dot should take.
  func color(for rating: Int) -> Color {
    rating <= currentValueProxy ? .vampireRed : .tertiarySystemGroupedBackground
  }
  
  /// Create a square for negative indices and a circle for positive.
  ///
  /// The shape is automatically sized and filled with the appropriate color.
  /// - Parameter index: The shape's index.
  /// - Returns: The generated shape.
  @ViewBuilder func shape(for index: Int) -> some View {
    if negativeSelection {
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
    
    if dots != currentValueProxy {
      currentValueProxy = Int16(dots)
      Global.hapticTap(engine: engine)
    } else {
      if currentValueProxy == 1 {
        if allowZero {
          currentValueProxy = 0
          Global.hapticTap(engine: engine)
        } else {
          // Don't allow the selection
          UINotificationFeedbackGenerator().notificationOccurred(.warning)
        }
      } else {
        currentValueProxy += currentValueProxy < 0 ? 1 : -1 // bring closer to 0
        Global.hapticTap(engine: engine)
      }
    }
  }
  
  /// Updates the receiver with the proxy's value.
  /// - Parameter newValue: The proxy's new value.
  func updateReceiver(_ newValue: Int16) {
    currentValue = newValue * (negativeSelection ? -1 : 1)
  }
  
}

struct DotSelector_Previews: PreviewProvider {
  static var previews: some View {
    DotSelector(current: .constant(3), min: 0, max: 11)
  }
}
