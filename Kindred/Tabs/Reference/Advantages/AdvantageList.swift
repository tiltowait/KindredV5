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
          label(for: advantage)
        }
      }
      
      Section(header: Text("Backgrounds")) {
        ForEach(viewModel.backgrounds) { advantage in
          label(for: advantage)
        }
      }
    }
    .navigationBarTitle("Advantages", displayMode: .inline)
    .listStyle(InsetGroupedListStyle())
  }
  
  func label(for advantage: Advantage) -> some View {
    NavigationLink(destination: AdvantageView(advantage: advantage)) {
      VStack(alignment: .leading) {
        Text(advantage.name)
          .font(.headline)
        Text(advantage.info)
          .font(.callout)
          .foregroundColor(.secondary)
      }
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
