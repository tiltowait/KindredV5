//
//  ClanList.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import SwiftUI

struct ClanList: View {
  
  @StateObject private var viewModel: ViewModel
  @Binding var clanSelectionLinkActive: Bool
  
  init(clans: [Clan], kindred: Kindred? = nil, dataController: DataController? = nil, link: Binding<Bool>? = nil) {
    let viewModel = ViewModel(clans: clans, kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
    _clanSelectionLinkActive = link ?? .constant(false)
  }
  
  var body: some View {
    List(viewModel.clans) { clan in
      NavigationLink(
        destination: ClanDetail(
          clan: clan,
          kindred: viewModel.kindred,
          dataController: viewModel.dataController,
          link: $clanSelectionLinkActive
        )
      ) {
        ClanRow(clan: clan)
      }
      .isDetailLink(false)
    }
    .listStyle(GroupedListStyle())
    .navigationBarTitle("Clans", displayMode: .inline)
  }
}

struct ClanList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ClanList(clans: DataController.preview.clans)
    }
  }
}
