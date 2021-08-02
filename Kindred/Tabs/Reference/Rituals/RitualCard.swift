//
//  RitualCard.swift
//  Kindred
//
//  Created by Jared Lindsay on 8/2/21.
//

import SwiftUI

struct RitualCard: View {
  
  let ritual: Ritual
  var action: ((Ritual) -> Void)?
  
  /// The ritual's name, level, and source.
  var header: some View {
    VStack(spacing: 5) {
      Text(ritual.name)
        .font(.system(size: 24, weight: .black, design: .serif))
      Text("Level \(ritual.level) \(ritual.flavor.rawValue)")
        .font(Font.system(.subheadline).smallCaps())
        .foregroundColor(.secondary)
      Text(ritual.pageReference)
        .font(.caption)
        .italic()
        .foregroundColor(.secondary)
    }
  }
  
  var body: some View {
    ReferenceCard(
      item: ritual,
      icon: ritual.discipline?.icon,
      contents: {
        header
        Divider()
        
        ScrollView {
          VStack(alignment: .leading, spacing: 10) {
            if let ingredients = ritual.ingredients {
              BoldLabel("Ingredients:", details: ingredients)
            }
            BoldLabel("Process:", details: ritual.process)
            Divider()
            
            Text(ritual.info)
          }
        }
      },
      addAction: action
    )
  }
}

#if DEBUG
struct RitualCard_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all).opacity(0.5)
      RitualCard(ritual: Ritual.example)
    }
  }
}
#endif
