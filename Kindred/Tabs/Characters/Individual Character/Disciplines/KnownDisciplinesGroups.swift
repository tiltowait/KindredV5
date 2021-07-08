//
//  KnownDisciplinesGroups.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct KnownDisciplinesGroups: View {
  
  @Environment(\.viewController) var viewController
  
  @StateObject private var viewModel: ViewModel
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    ForEach(viewModel.kindred.knownDisciplines) { discipline in
      DisclosureGroup {
        ForEach(viewModel.knownPowers(for: discipline)) { power in
          Button {
            show(power: power)
          } label: {
            PowerRow(power: power)
              .contentShape(Rectangle())
          }
          .buttonStyle(PlainButtonStyle())
        }
        .onDelete { offsets in
          removePowers(at: offsets, in: discipline)
        }
      } label: {
        DisciplineRow(discipline: discipline, level: viewModel.kindred.level(of: discipline))
      }
    }
  }
  
  func show(power: Power) {
    viewController?.present {
      PowerCard(power: power)
    }
  }
  
  func removePowers(at offsets: IndexSet, in discipline: Discipline) {
    viewModel.removePowers(at: offsets, in: discipline)
  }
}

#if DEBUG
struct KnownDisciplinesList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        Section(header: DisciplineHeader("Disciplines", buttonPressed: .constant(false))) {
          KnownDisciplinesGroups(kindred: Kindred.example, dataController: DataController.preview)
        }
      }
      .listStyle(GroupedListStyle())
    }
  }
}
#endif
