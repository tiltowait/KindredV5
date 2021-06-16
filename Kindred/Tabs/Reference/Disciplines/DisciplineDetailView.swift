//
//  DisciplineDetailView.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import SwiftUI
import CoreData

struct DisciplineDetailView: View {
  
  let discipline: Discipline
  
  var body: some View {
    List {
      Section(header: Text(discipline.info),
              footer: IconFooter(icon: discipline.icon)) {
        ForEach(0..<discipline.allPowers.count) { index in
          DisclosureGroup {
            PowerInfoView(power: power(at: index))
          } label: {
            PowerRow(power: power(at: index))
              .contentShape(Rectangle())
          }
        }
      }
    }
    .listStyle(GroupedListStyle())
    .navigationTitle(discipline.name)
  }
  
  func power(at index: Int) -> Power {
    discipline.allPowers[index]
  }
  
}

struct DisciplinePowerList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DisciplineDetailView(discipline: Discipline.example)
    }
  }
}
