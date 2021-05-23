//
//  PowerLabelRow.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import SwiftUI

struct PowerLabelRow: View {
  
  @State private var isExpanded = false
  let power: Power
  
  var body: some View {
    VStack {
      HStack(alignment: .bottom) {
        Text("\(power.level)")
          .foregroundColor(.secondary)
          .font(.caption)
        Text(power.powerName)
          .font(.headline)
        Spacer()
        Text(power.sourceBook.reference(page: power.page))
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
  }
  
}


struct PowerLabelRow_Previews: PreviewProvider {
  static var previews: some View {
    PowerLabelRow(power: Global.tdController.disciplines.first!.allPowers[2])
      .previewLayout(.sizeThatFits)
  }
}
