//
//  LoresheetDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import SwiftUI

struct LoresheetDetail: View {
  
  @StateObject var viewModel: ViewModel
  
  init(loresheet: Loresheet, kindred: Kindred? = nil) {
    let viewModel = ViewModel(loresheet: loresheet, kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List {
      Text(viewModel.loresheet.info)
      if let clanRestrictions = viewModel.clanRestrictions {
        Text("\(clanRestrictions) only")
          .foregroundColor(.vampireRed)
          .italic()
          .centered()
      }
      
      Section(header: Text("Entries")) {
        ForEach(viewModel.loresheet.entries) { entry in
          LoresheetEntryDetail(entry: entry, kindred: viewModel.kindred)
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarTitle(viewModel.loresheet.name, displayMode: .inline)
  }
}

#if DEBUG
struct LoresheetDetail_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      LoresheetDetail(loresheet: Loresheet.example)
    }
  }
}
#endif
