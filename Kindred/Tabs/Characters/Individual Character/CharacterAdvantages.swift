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
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List {
      Button("Add Advantage") {
        showingAddAdvantageSheet.toggle()
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarTitle("Merits, Flaws, Backgrounds", displayMode: .inline)
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
