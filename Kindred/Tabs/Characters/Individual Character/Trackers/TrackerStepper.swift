//
//  TrackerStepper.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/24/21.
//

import SwiftUI

struct TrackerStepper: View {
  
  let label: LocalizedStringKey
  @Binding var value: Int16
  let onIncrement: (() -> Void)?
  let onDecrement: (() -> Void)?
  
  let min: Int16
  let max: Int16
  
  init(
    _ label: LocalizedStringKey,
    value: Binding<Int16>,
    in range: ClosedRange<Int16>,
    onIncrement: (() -> Void)? = nil,
    onDecrement: (() -> Void)? = nil
  ) {
    self.label = label
    _value = value
    
    self.min = range.min()!
    self.max = range.max()!
    
    self.onIncrement = onIncrement
    self.onDecrement = onDecrement
  }
  
  var body: some View {
    Stepper(onIncrement: increment, onDecrement: decrement) {
      HStack {
        Text(label)
          .bold()
        Spacer()
        Text("\(value)")
          .padding(.trailing)
      }
    }
  }
  
  func increment() {
    if value < max {
      // We need to put the onIncrement() (and onDecrement()) call
      // before we actually do the incrementation. This is because
      // Kindred.healthString is automatically initialized as a
      // string of repeating characters, count Kindred.health. If
      // we call onIncrement *after* incrementing, healthString will
      // become initialized as a 1-character string, then have
      // another character added to it, resulting in an extra stress
      // box.
      //
      // The same is true for Kindred.willpowerString.
      onIncrement?()
      value += 1
    }
  }
  
  func decrement() {
    if value > min {
      onDecrement?()
      value -= 1
    }
  }
}

struct TrackerStepper_Previews: PreviewProvider {
  static var previews: some View {
    TrackerStepper("Health:", value: .constant(5), in: 1...15)
  }
}
