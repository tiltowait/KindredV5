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
  
  var body: some View {
    VStack(alignment: .leading, spacing: 3) {
      HStack(alignment: .center) {
        if showLevel {
          Text("\(ritual.level)")
            .foregroundColor(.secondary)
            .font(.caption)
        }
        Text(ritual.name)
          .font(.headline)
      }
      
      HStack {
        Spacer()
        Text(ritual.pageReference)
          .multilineTextAlignment(.trailing)
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
  }
}

#if DEBUG
struct RitualRow_Previews: PreviewProvider {
  static var previews: some View {
    RitualRow(ritual: Ritual.example, showLevel: true)
  }
}
#endif
