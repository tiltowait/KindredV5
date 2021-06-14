//
//  TraitBlockView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

struct TraitBlockView: View {
  
  let title: String
  let traits: [[(String, Int16)]]
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.headline)
      HStack {
        ForEach(traits.indices) { index in
          VStack(alignment: .leading) {
            ForEach(self.traits[index], id: \.0) { trait in
              Text("\(trait.0) \(dots(for: trait.1))")
                .font(.caption)
            }
          }
        }
      }
    }
  }
  
  func dots(for rating: Int16) -> String {
    Array(repeating: "•", count: Int(rating)).joined()
  }
}

struct TraitBlockView_Previews: PreviewProvider {
  static var previews: some View {
    TraitBlockView(title: "Attributes", traits: [[("Strength", 3)], [("Charisma", 4)], [("Intelligence", 2)]])
      .previewLayout(.sizeThatFits)
  }
}
