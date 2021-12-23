//
//  KnownLoresheetGroups.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import SwiftUI

struct KnownLoresheetGroups: View {
  
  @StateObject var viewModel: ViewModel
  @EnvironmentObject var dataController: DataController
  
  @Binding var lockIdentifier: String?
  
  init(kindred: Kindred, lockIdentifier: Binding<String?>) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
    _lockIdentifier = lockIdentifier
  }
  
  var body: some View {
    ForEach(viewModel.knownLoresheets) { loresheet in
      row(loresheet: loresheet)
    }
  }
  
  @ViewBuilder func row(loresheet: Loresheet) -> some View {
    if dataController.isPurchased(item: loresheet) {
      DisclosureGroup {
        ForEach(viewModel.entries(for: loresheet)) { entry in
          LoresheetEntryDetail(entry: entry, kindred: nil)
        }
      } label: {
        ReferenceRow(loresheet.name, secondary: loresheet.pageReference)
      }
    } else {
      // The only way for this to happen is if the user imports
      // a character sheet that contains restricted loresheets.
      // While we *could* prevent the user from doing so, it is
      // a nicer user flow to import and simply prompt them to
      // unlock whenever they try to view restricted material.
      Button {
        lockIdentifier = loresheet.unlockIdentifier
      } label: {
        ReferenceRow(
          loresheet.name,
          secondary: loresheet.pageReference,
          color: loresheet.sourceBook.color,
          unlocked: false
        )
        .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
    }
  }
}

#if DEBUG
struct KnownLoresheetGroups_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        Section(header: Text("Loresheets")) {
          KnownLoresheetGroups(kindred: Kindred.example, lockIdentifier: .constant(nil))
            .environmentObject(DataController.preview)
        }
      }
    }
  }
}
#endif
