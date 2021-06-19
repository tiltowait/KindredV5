//
//  ClanRow.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import SwiftUI

struct ClanRow: View {
  
  let clan: Clan
  
  var body: some View {
    HStack {
      Image(clan.icon)
        .resizable()
        .scaledToFit()
      VStack(alignment: .leading) {
        Text(clan.name)
          .font(.headline)
        Text(clan.randomNicknames(count: 1).joined(separator: ", "))
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      Spacer()
      Text(clan.pageReference)
        .font(.caption2)
        .italic()
        .foregroundColor(.secondary)
        .multilineTextAlignment(.trailing)
    }
    // TODO: These modifiers will change once all the clan icons have normalized sizes
    .frame(height: 40)
  }
}

struct ClanRow_Previews: PreviewProvider {
  static var previews: some View {
    ClanRow(clan: Clan.example)
  }
}
