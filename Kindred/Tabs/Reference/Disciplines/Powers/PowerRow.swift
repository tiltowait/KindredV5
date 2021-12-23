//
//  PowerRow.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import SwiftUI

struct PowerRow: View {
  
  @State private var isExpanded = false
  let power: Power
  let isUnlocked: Bool
  
  var body: some View {
    VStack {
      HStack(alignment: .center) {
        if isUnlocked == false {
          Image(systemName: "lock.fill")
            .foregroundColor(.secondary)
        } else {
          Text("\(power.level)")
            .foregroundColor(.secondary)
            .font(.caption)
        }
        Text(power.name)
          .font(.headline)
          .foregroundColor(isUnlocked ? .primary : .secondary)
        Spacer()
        
        Text(power.sourceBook.reference(page: power.page))
          .multilineTextAlignment(.trailing)
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
  }
  
}

#if DEBUG
struct PowerLabelRow_Previews: PreviewProvider {
  static var previews: some View {
    PowerRow(power: Power.example, isUnlocked: true)
      .previewLayout(.sizeThatFits)
    PowerRow(power: Power.example, isUnlocked: false)
      .previewLayout(.sizeThatFits)
  }
}
#endif
