//
//  KnownDisciplinesGroups.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct KnownDisciplinesGroups: View {
  
  @StateObject private var viewModel: ViewModel
  
  init(kindred: Kindred) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    if viewModel.noKnownDisciplines {
      Text("Tap the button above to add a Discipline")
        .foregroundColor(.secondary)
    } else {
      ForEach(viewModel.kindred.knownDisciplines) { discipline in
        DisclosureGroup {
          ForEach(viewModel.knownPowers(forDiscipline: discipline)) { power in
            PowerRow(power: power)
          }
        } label: {
          DisciplineRow(discipline: discipline)
        }
      }
    }
  }
}

struct KnownDisciplinesList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        Section(header: AdvantageHeader("Disciplines", binding: .constant(false))) {
          KnownDisciplinesGroups(kindred: Kindred.example)
        }
      }
      .listStyle(GroupedListStyle())
    }
  }
}
