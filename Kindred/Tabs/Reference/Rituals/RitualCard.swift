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
    .accessibilityElement(children: .combine)
    .accessibilityLabel(Text("\(ritual.name), level \(ritual.level) \(ritual.flavor.rawValue), \(ritual.pageReference)"))
  }
  
  var accessibilityLabel: Text {
    var label = ""
    
    if let ingredients = ritual.ingredients {
      label += "Ingredients: \(ingredients), "
    }
    
    label += "Process: \(ritual.process), System: \(ritual.info)"
    return Text(label)
  }
  
  var body: some View {
    ReferenceCard(
      item: ritual,
      icon: ritual.discipline.icon,
      contents: {
        header
        Divider()
        
        ScrollView {
          VStack(alignment: .leading, spacing: 10) {
            Text(ritual.info)
            Divider()
            
            BoldLabel("System:", details: ritual.system)
            if let ingredients = ritual.ingredients {
              BoldLabel("Ingredients:", details: ingredients)
            }
            BoldLabel("Process:", details: ritual.process)
            
          }
          .accessibilityElement(children: .combine)
          .accessibilityLabel(accessibilityLabel)
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
