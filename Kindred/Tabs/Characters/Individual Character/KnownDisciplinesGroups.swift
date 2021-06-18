//
//  KnownDisciplinesGroups.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct KnownDisciplinesGroups: View {
  
  @StateObject private var viewModel: ViewModel
  @Binding private var power: Power?
  @Binding private var opacity: Double
  
  init(kindred: Kindred, dataController: DataController, binding: Binding<Power?>, opacity: Binding<Double>) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
    
    _power = binding
    _opacity = opacity
  }
  
  var body: some View {
    if viewModel.noKnownDisciplines {
      Text("Tap the button above to add a Discipline")
        .foregroundColor(.secondary)
    } else {
      ForEach(viewModel.kindred.knownDisciplines) { discipline in
        DisclosureGroup {
          ForEach(viewModel.knownPowers(for: discipline)) { power in
            PowerRow(power: power)
              .onTapGesture {
                show(power: power)
              }
          }
          .onDelete { offsets in
            removePowers(at: offsets, in: discipline)
          }
        } label: {
          DisciplineRow(discipline: discipline)
        }
      }
    }
  }
  
  func show(power: Power) {
    self.power = power
    withAnimation {
      opacity = 1
    }
  }
  
  func removePowers(at offsets: IndexSet, in discipline: Discipline) {
    viewModel.removePowers(at: offsets, in: discipline)
  }
}

struct KnownDisciplinesList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        Section(header: AdvantageHeader("Disciplines", binding: .constant(false))) {
          KnownDisciplinesGroups(kindred: Kindred.example, dataController: DataController.preview, binding: .constant(Power.example), opacity: .constant(0))
        }
      }
      .listStyle(GroupedListStyle())
    }
  }
}
