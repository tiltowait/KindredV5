//
//  RitualRow.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/27/21.
//

import SwiftUI

struct RitualRow: View {
  
  let ritual: Ritual
  
  var body: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text(ritual.name)
        .font(.headline)
      
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
    RitualRow(ritual: Ritual.example)
  }
}
#endif
