//
//  KnownLoresheetGroups.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import SwiftUI

struct KnownLoresheetGroups: View {
  
  @StateObject var viewModel: ViewModel
  
  init(kindred: Kindred) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    ForEach(viewModel.knownLoresheets) { loresheet in
      DisclosureGroup {
        ForEach(viewModel.entries(for: loresheet)) { entry in
          LoresheetEntryDetail(entry: entry, kindred: nil)
        }
      } label: {
        ReferenceRow(loresheet.name, secondary: loresheet.pageReference)
    }
    }
  }
}

#if DEBUG
struct KnownLoresheetGroups_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        Section(header: Text("Loresheets")) {
          KnownLoresheetGroups(kindred: Kindred.example)
        }
      }
      .listStyle(InsetGroupedListStyle())
    }
  }
}
#endif
