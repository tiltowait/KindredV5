//
//  DisciplineRow.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/25/21.
//

import SwiftUI

struct DisciplineRow: View {
  let discipline: Discipline
  
  var body: some View {
    HStack {
      Image(discipline.disciplineIcon)
        .clipShape(Circle())
      VStack(alignment: .leading) {
        Text(discipline.name)
          .font(.headline)
        
        Text(discipline.info)
          .foregroundColor(.secondary)
      }
    }
    
  }
}

struct DisciplineRow_Previews: PreviewProvider {
  static var previews: some View {
    DisciplineRow(discipline: DataController.Example.discipline)
      .previewLayout(.sizeThatFits)
  }
}
