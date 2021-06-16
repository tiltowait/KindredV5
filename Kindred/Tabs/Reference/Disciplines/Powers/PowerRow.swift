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
  
  var body: some View {
    VStack {
      HStack(alignment: .center) {
        Text("\(power.level)")
          .foregroundColor(.secondary)
          .font(.caption)
        Text(power.name)
          .font(.headline)
        Spacer()
        
        if power.sourceBook != .core {
          Circle()
            .foregroundColor(power.sourceBook.color)
            .frame(width: 15, height: 15)
        }
        
        Text(power.sourceBook.reference(page: power.page))
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
  }
  
}


struct PowerLabelRow_Previews: PreviewProvider {
  static var previews: some View {
    PowerRow(power: Power.example)
      .previewLayout(.sizeThatFits)
  }
}
