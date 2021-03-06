//
//  RitualRow.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/27/21.
//

import SwiftUI

struct RitualRow: View {
  
  let ritual: Ritual
  let showLevel: Bool
  let isUnlocked: Bool
  
  var mainLabelColor: Color {
    isUnlocked ? .primary : .secondary
  }
  
  var accessibilityLabel: String {
    if isUnlocked {
      return "Locked: \(ritual.name)"
    }
    
    return "\(ritual.name): \(ritual.info)"
  }
  
  var body: some View {
    HStack(spacing: 5) {
      if isUnlocked == false {
        Image(systemName: "lock.fill")
          .foregroundColor(mainLabelColor)
          .opacity(0.5)
      }
      VStack(alignment: .leading, spacing: 5) {
        HStack(alignment: .top) {
          if showLevel {
            Text("\(ritual.level)")
              .foregroundColor(.secondary)
              .font(.caption)
              .padding(3)
          }
          
          VStack(alignment: .leading) {
            Text(ritual.name)
              .font(.headline)
              .foregroundColor(mainLabelColor)
            if isUnlocked {
              Text(ritual.info)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            }
          }
        }
        
        HStack {
          Spacer()
          Text(ritual.pageReference)
            .italic()
            .font(.caption)
            .multilineTextAlignment(.trailing)
            .foregroundColor(.secondary)
        }
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel(Text(accessibilityLabel))
  }
}

#if DEBUG
struct RitualRow_Previews: PreviewProvider {
  static var previews: some View {
    RitualRow(ritual: Ritual.example, showLevel: true, isUnlocked: true)
      .previewLayout(.sizeThatFits)
    RitualRow(ritual: Ritual.example, showLevel: false, isUnlocked: false)
      .previewLayout(.sizeThatFits)
  }
}
#endif
