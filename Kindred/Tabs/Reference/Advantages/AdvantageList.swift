//
//  AdvantageList.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import SwiftUI

struct AdvantageList: View {
  
  @StateObject var viewModel: ViewModel
  
  init(kindred: Kindred? = nil, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List {
      Section(header: Text("Merits & Flaws")) {
        ForEach(viewModel.merits) { advantage in
          link(for: advantage)
        }
      }
      
      Section(header: Text("Backgrounds")) {
        ForEach(viewModel.backgrounds) { advantage in
          link(for: advantage)
        }
      }
    }
    .listStyle(.insetGrouped)
    .navigationTitle("Advantages")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  func link(for advantage: Advantage) -> some View {
    NavigationLink(destination: AdvantageView(advantage: advantage, kindred: viewModel.kindred, dataController: viewModel.dataController!)) {
      AdvantageRow(advantage: advantage)
    }
  }
}

struct AdvantageList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AdvantageList(dataController: DataController.preview)
    }
  }
}
