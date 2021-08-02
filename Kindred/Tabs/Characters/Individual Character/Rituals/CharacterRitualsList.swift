//
//  CharacterRitualsList.swift
//  Kindred
//
//  Created by Jared Lindsay on 8/2/21.
//

import SwiftUI

struct CharacterRitualsList: View {
  
  @StateObject private var viewModel: ViewModel
  @State private var ritualList: RitualList?
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List {
      Section(header: Text("Experience cost: Level × 3")) { }
      
      section(
        title: "Blood Sorcery Rituals",
        addAction: addRitual,
        rituals: viewModel.rituals
      )
      section(
        title: "Oblivion Ceremonies",
        addAction: addCeremony,
        rituals: viewModel.ceremonies
      )
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarTitle("Rituals", displayMode: .inline)
    .sheet(item: $ritualList) { list in
      NavigationView {
        list
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                ritualList = nil
              }
            }
          }
      }
    }
  }
  
  func header(title: LocalizedStringKey, addAction: @escaping () -> Void) -> some View {
    HStack {
      Text(title)
      Spacer()
      Button(action: addAction) {
        Label("Add ritual", systemImage: "plus.circle")
          .labelStyle(IconOnlyLabelStyle())
      }
    }
  }
  
  func section(
    title: LocalizedStringKey,
    addAction: @escaping () -> Void,
    rituals: [Ritual]
  ) -> some View {
    Section(header: header(title: title, addAction: addAction)) {
      if rituals.isEmpty {
        Button(action: addAction) {
          Label("Add item", systemImage: "plus.circle")
        }
      } else {
        ForEach(rituals) { ritual in
          Button {
            show(ritual: ritual)
          } label: {
            RitualRow(ritual: ritual)
              .contentShape(Rectangle())
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
    }
  }
  
  func show(ritual: Ritual) {
    UIViewController.topMost?.present {
      RitualCard(ritual: ritual)
    }
  }
  
  func addRitual() {
    ritualList = RitualList(flavor: .ritual, kindred: viewModel.kindred, dataController: viewModel.dataController)
  }
  
  func addCeremony() {
    ritualList = RitualList(flavor: .ceremony, kindred: viewModel.kindred, dataController: viewModel.dataController)
  }
  
}

#if DEBUG
struct CharacterRitualsList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      CharacterRitualsList(kindred: Kindred.example, dataController: DataController.preview)
    }
  }
}
#endif
