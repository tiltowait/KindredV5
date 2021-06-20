//
//  ClanList.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import SwiftUI

struct ClanList: View {
  
  @StateObject private var viewModel: ViewModel
  
  init(kindred: Kindred? = nil, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List(viewModel.clans) { clan in
      NavigationLink(
        destination: ClanDetail(
          clan: clan,
          kindred: viewModel.kindred,
          dataController: viewModel.dataController
        )
      ) {
        ClanRow(clan: clan)
      }
    }
    .listStyle(GroupedListStyle())
    .navigationBarTitle("Clans", displayMode: .inline)
  }
}

struct ClanList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ClanList(dataController: DataController.preview)
    }
  }
}
