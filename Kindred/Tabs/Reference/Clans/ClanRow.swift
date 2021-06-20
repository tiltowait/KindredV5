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
    ReferenceRow(
      clan.name,
      subtitle: clan.nicknames.randomElement(),
      secondary: clan.pageReference,
      icon: Image(clan.icon)
    )
  }
}

struct ClanRow_Previews: PreviewProvider {
  static var previews: some View {
    ClanRow(clan: Clan.example)
  }
}
