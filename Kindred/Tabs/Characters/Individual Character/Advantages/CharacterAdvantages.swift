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
  @State private var optionsToBeDeleted = 0
  
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var instructions: some View {
    Text("Press + to add a merit, background, or flaw.")
      .font(.system(size: 18))
      .padding(.top)
  }
  
  var advantageList: some View {
    ForEach(viewModel.coalesced) { coalesced in
      Section {
        AdvantageRow(advantage: coalesced.advantage)
        ForEach(coalesced.containers) { container in
          AdvantageOptionView(container: container)
        }
        .onDelete { offsets in
          viewModel.deleteOption(offsets, parent: coalesced)
        }
      }
    }
  }
  
  var addAdvantageButton: some View {
    Button {
      showingAddAdvantageSheet.toggle()
    }
    label: {
      Image(systemName: "plus")
        .imageScale(.large)
    }
  }
  
  var body: some View {
    List {
      if viewModel.coalesced.isEmpty {
        Section(header: instructions) { }
          .textCase(nil)
      } else {
        advantageList
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarItems(trailing: addAdvantageButton)
    .navigationBarTitle("Advantages", displayMode: .inline)
    .sheet(isPresented: $showingAddAdvantageSheet) {
      addAdvantageSheet
    }
  }
  
  var addAdvantageSheet: some View {
    NavigationView {
      AdvantageList(kindred: viewModel.kindred, dataController: viewModel.dataController)
    }
  }
  
}

struct CharacterAdvantages_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      CharacterAdvantages(kindred: Kindred.example, dataController: DataController.preview)
    }
  }
}
