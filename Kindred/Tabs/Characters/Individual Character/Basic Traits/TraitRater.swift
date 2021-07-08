//
//  TraitRater.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI

struct TraitRater: View {
  
  @ObservedObject var kindred: Kindred
  let keyPath: ReferenceWritableKeyPath<Kindred, Int16>
  let max: Int16
  let reference: String
  
  @State private var binding: Int16
  @State private var showingReferenceAlert = false
  
  let size: CGFloat = 17
  let spacing: CGFloat = 5

  init(
    kindred: Kindred,
    keyPath: ReferenceWritableKeyPath<Kindred, Int16>,
    max: Int16, reference: String
  ) {
    self.kindred = kindred
    self.keyPath = keyPath
    self.reference = reference
    self.max = max
    
    _binding = State(wrappedValue: kindred[keyPath: keyPath])
  }
  
  var label: String {
    keyPath.stringValue.unCamelCased.capitalized
  }
  
  var body: some View {
    HStack {
      Text("\(label):")
        .bold()
      
      Spacer()
      
      DotSelector(current: $binding, min: 0, max: max)
      
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
    .onDisappear(perform: updateTrait)
  }
  
  /// Update the character's trait with the value of the binding.
  func updateTrait() {
    kindred[keyPath: keyPath] = binding
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
