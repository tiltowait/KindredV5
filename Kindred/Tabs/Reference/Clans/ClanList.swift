//
//  ClanList.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import SwiftUI

struct ClanList: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @StateObject private var viewModel: ViewModel
  @State private var lockedItem: String?
  
  init(kindred: Kindred? = nil, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List(viewModel.clans) { clan in
      if viewModel.isUnlocked(clan: clan) {
        NavigationLink(
          destination: ClanDetail(
            clan: clan,
            kindred: viewModel.kindred
          )
        ) {
          ClanRow(clan: clan, unlocked: true)
        }
      } else {
        Button {
          lockedItem = clan.unlockIdentifier
        } label: {
          ClanRow(clan: clan, unlocked: false)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarTitle("Clans", displayMode: .inline)
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        if viewModel.showCancelButton {
          Button("Cancel", action: dismiss)
        }
      }
    }
    .sheet(item: $lockedItem) { item in
      UnlockView(highlights: [item])
    }
  }
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
}

struct ClanList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ClanList(dataController: DataController.preview)
    }
  }
}
