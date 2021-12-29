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
  
  var label: Text {
    if let level = level {
      return Text("\(discipline.name) \(level), \(discipline.info)")
    }
    return Text("\(discipline.name), \(discipline.info)")
  }
  
  var body: some View {
    ReferenceRow(name, subtitle: discipline.info, icon: Image(discipline.icon))
      .accessibilityElement(children: .combine)
      .accessibilityLabel(label)
  }
}

#if DEBUG
struct DisciplineRow_Previews: PreviewProvider {
  static var previews: some View {
    DisciplineRow(discipline: Discipline.example, level: 3)
      .previewLayout(.sizeThatFits)
  }
}
#endif
