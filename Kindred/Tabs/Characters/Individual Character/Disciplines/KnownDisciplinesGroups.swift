//
//  KnownDisciplinesGroups.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct KnownDisciplinesGroups: View {
  
  @Environment(\.viewController) var viewController
  @EnvironmentObject var dataController: DataController
  
  @StateObject private var viewModel: ViewModel
  @Binding private var lockedItem: String?
  
  init(kindred: Kindred, lockedItem: Binding<String?>) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
    self._lockedItem = lockedItem
  }
  
  var body: some View {
    ForEach(viewModel.kindred.knownDisciplines) { discipline in
      DisclosureGroup {
        ForEach(viewModel.knownPowers(for: discipline)) { power in
          Button {
            show(power: power)
          } label: {
            PowerRow(
              power: power,
              isUnlocked: dataController.isPurchased(item: power)
            )
            .contentShape(Rectangle())
          }
          .buttonStyle(.plain)
        }
        .onDelete { offsets in
          removePowers(at: offsets, in: discipline)
        }
      } label: {
        DisciplineRow(
          discipline: discipline,
          level: viewModel.kindred.level(of: discipline)
        )
      }
    }
  }
  
  func show(power: Power) {
    if dataController.isPurchased(item: power) {
      viewController?.present {
        PowerCard(power: power)
      }
    } else {
      lockedItem = power.unlockIdentifier
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
          KnownDisciplinesGroups(kindred: Kindred.example, lockedItem: .constant(nil))
            .environmentObject(DataController.preview)
        }
      }
    }
  }
}
#endif
