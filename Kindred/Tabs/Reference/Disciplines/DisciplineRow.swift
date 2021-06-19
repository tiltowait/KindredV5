//
//  DisciplineRow.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/25/21.
//

import SwiftUI

struct DisciplineRow: View {
  
  let discipline: Discipline
  var level: Int? = nil
  
  var name: String {
    if let level = level {
      let dots = String(repeating: "•", count: level)
      return "\(discipline.name) \(dots)"
    } else {
      return discipline.name
    }
  }
  
  var body: some View {
    HStack {
      Image(discipline.icon)
        .resizable()
        .frame(width: 55, height: 55)
      VStack(alignment: .leading) {
        Text(name)
          .font(.headline)
        
        Text(discipline.info)
          .foregroundColor(.secondary)
      }
    }
    
  }
}

struct DisciplineRow_Previews: PreviewProvider {
  static var previews: some View {
    DisciplineRow(discipline: Discipline.example, level: 3)
      .previewLayout(.sizeThatFits)
  }
}
