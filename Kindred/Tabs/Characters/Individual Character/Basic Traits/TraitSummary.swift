//
//  TraitSummary.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

struct TraitSummary: View {
  
  let title: String
  let traits: [[(String, Int16)]]
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.headline)
      HStack(alignment: .center) {
        ForEach(traits.indices) { index in
          VStack(alignment: .leading) {
            ForEach(self.traits[index], id: \.0) { trait in
              HStack {
                Text("\(trait.0):")
                  .font(.caption)
                Spacer()
                Text("\(trait.1)")
                  .font(.caption)
              }
            }
          }
        }
      }
      .minimumScaleFactor(0.01)
      .lineLimit(1)
    }
  }
  
}

struct TraitSummary_Previews: PreviewProvider {
  static var previews: some View {
    TraitSummary(title: "Attributes", traits: [[("Strength", 3)], [("Charisma", 4)], [("Intelligence", 2)]])
      .previewLayout(.sizeThatFits)
  }
}
