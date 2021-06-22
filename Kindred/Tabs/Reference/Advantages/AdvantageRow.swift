//
//  AdvantageRow.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import SwiftUI

struct AdvantageRow: View {
  
  let advantage: Advantage
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(advantage.name)
        .font(.headline)
      Text(advantage.info)
        .font(.callout)
        .foregroundColor(.secondary)
    }
  }
}

struct AdvantageRow_Previews: PreviewProvider {
  static var previews: some View {
    AdvantageRow(advantage: Advantage.example)
  }
}
