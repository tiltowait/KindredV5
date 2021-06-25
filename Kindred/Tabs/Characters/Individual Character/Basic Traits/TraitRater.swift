//
//  TraitRater.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI

struct TraitRater: View {
  
  @State private var showingReferenceAlert = false
  let size: CGFloat = 17
  let spacing: CGFloat = 5
  
  @ObservedObject var kindred: Kindred
  let keyPath: ReferenceWritableKeyPath<Kindred, Int16>
  let max: Int
  let reference: String
  
  var label: String {
    keyPath.stringValue.unCamelCased.capitalized
  }
  
  var body: some View {
    HStack {
      Text("\(label):")
        .bold()
      
      Spacer()
      
      ForEach(1...max) { index in
        Circle()
          .fill(color(for: index))
          .frame(width: size, height: size)
          .onTapGesture {
            updateValue(to: index)
          }
        
        // Make a gap every 5 dots for legibility purposes
        if index > 0 && index % 5 == 0 {
          Circle().fill(Color.clear)
            .frame(width: 1, height: 1)
        }
      }
      
      // Reference button
      Button {
        showingReferenceAlert.toggle()
      } label: {
        Label("Reference", systemImage: "info.circle")
          .labelStyle(IconOnlyLabelStyle())
      }
    }
    .alert(isPresented: $showingReferenceAlert) {
      Alert(title: Text(label), message: Text(reference), dismissButton: .default(Text("OK")))
    }
  }
  
  /// Determine the color for a dot at a given rating.
  ///
  /// If `rating` is greater than the receiver's current value, then the dot is an "unfilled" color.
  /// Otherwise, it will receive a "filled" color.
  /// - Parameter rating: The index of the dot in question.
  /// - Returns: The color the dot should take.
  func color(for rating: Int) -> Color {
    rating <= kindred[keyPath: keyPath] ? .vampireRed : .tertiarySystemGroupedBackground
  }
  
  /// Update the referenced value.
  /// - Parameter newValue: The receiver's new value.
  func updateValue(to newValue: Int) {
    if newValue > 1 {
      kindred[keyPath: keyPath] = Int16(newValue)
    } else {
      // If the current value is 1, set to 0. Otherwise, set to 1.
      let current = kindred[keyPath: keyPath]
      kindred[keyPath: keyPath] = current == 1 ? 0 : 1
    }
  }
  
}

#if DEBUG
struct TraitRater_Previews: PreviewProvider {
  static var previews: some View {
    TraitRater(kindred: Kindred.example, keyPath: \.strength, max: 5, reference: "Test reference")
      .previewLayout(.sizeThatFits)
  }
}
#endif