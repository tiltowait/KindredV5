//
//  DisciplineDetailView.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import SwiftUI
import CoreData

struct DisciplineDetailView: View {
  
  @State private var disclosureFlags: [Bool]
  let discipline: Discipline
  
  init(discipline: Discipline) {
    self.discipline = discipline
    let flags = Array(repeating: false, count: discipline.allPowers.count)
    _disclosureFlags = State(wrappedValue: flags)
  }
  
  var body: some View {
    List {
      Section(header: Text(discipline.info),
              footer: IconFooter(icon: discipline.disciplineIcon)) {
        ForEach(0..<discipline.allPowers.count) { index in
          DisclosureGroup(
            isExpanded: $disclosureFlags[index],
            content: { PowerInfoView(power: power(at: index)) },
            label: {
              PowerRow(power: power(at: index))
                .contentShape(Rectangle())
                .onTapGesture {
                  withAnimation {
                    self.disclosureFlags[index].toggle()
                  }
                }
            }
          )
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
      DisciplineDetailView(discipline: DataController.Example.discipline)
    }
  }
}
