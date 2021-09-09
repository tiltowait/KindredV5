//
//  CharacterAdvantages.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import SwiftUI

struct CharacterAdvantages: View {
  
  @StateObject var viewModel: ViewModel
  
  @State private var showingAddAdvantageSheet = false
  @State private var showingDeleteAdvantageAlert = false
  @State private var showingLoresheetAdder = false
  
  @State private var lockIdentifier: String?
  
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var menu: some View {
    Menu {
      Button {
        showingAddAdvantageSheet.toggle()
      } label: {
        Label("Add advantage or flaw", systemImage: "person")
      }
      Button {
        showingLoresheetAdder.toggle()
      } label: {
        Label("Add loresheet", systemImage: "book")
      }
    } label: {
      Label("Add advantage", systemImage: "plus.circle")
        .imageScale(.large)
        .labelStyle(IconOnlyLabelStyle())
    }
  }
  
  var instructions: some View {
    Text("Press + to add a merit, background, loresheet, or flaw.")
      .font(.system(size: 18))
      .padding(.top)
  }
  
  var advantageList: some View {
    Group {
      ForEach(viewModel.coalesced) { coalesced in
        Section {
          AdvantageRow(advantage: coalesced.advantage)
          ForEach(coalesced.containers) { container in
            AdvantageOptionView(container: container, dataController: viewModel.dataController)
          }
          .onDelete { offsets in
            viewModel.deleteOption(offsets, parent: coalesced)
          }
        }
      }
      if viewModel.hasLoresheets {
        Section(header: Text("Loresheets")) {
          KnownLoresheetGroups(
            kindred: viewModel.kindred,
            lockIdentifier: $lockIdentifier
          )
        }
      }
    }
  }
  
  var body: some View {
    List {
      if !viewModel.hasAdvantages {
        Section(header: instructions) { }
          .textCase(nil)
      } else {
        advantageList
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarItems(trailing: menu)
    .navigationBarTitle("Advantages", displayMode: .inline)
    .sheet(isPresented: $showingAddAdvantageSheet) {
      addAdvantageSheet
    }
    .sheet(isPresented: $showingLoresheetAdder) {
      AddLoresheetList(
        kindred: viewModel.kindred,
        dataController: viewModel.dataController
      )
    }
    .sheet(item: $lockIdentifier) { item in
      UnlockView(highlights: [item])
    }
    .onDisappear(perform: viewModel.save)
  }
  
  var addAdvantageSheet: some View {
    NavigationView {
      AdvantageList(kindred: viewModel.kindred, dataController: viewModel.dataController)
    }
  }
  
}

#if DEBUG
struct CharacterAdvantages_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      CharacterAdvantages(kindred: Kindred.example, dataController: DataController.preview)
        .environmentObject(DataController.preview)
    }
  }
}
#endif
