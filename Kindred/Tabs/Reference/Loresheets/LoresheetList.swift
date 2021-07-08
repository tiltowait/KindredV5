//
//  LoresheetList.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import SwiftUI

struct LoresheetList: View {
  
  @FetchRequest(
    entity: Loresheet.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Loresheet.zName, ascending: true)]
  ) var loresheets: FetchedResults<Loresheet>
  
  var body: some View {
    List(loresheets) { loresheet in
      NavigationLink(destination: LoresheetDetail(loresheet: loresheet)) {
        ReferenceRow(loresheet.name, secondary: loresheet.pageReference)
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarTitle("Loresheets", displayMode: .inline)
  }
  
}

struct LoresheetList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      LoresheetList()
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
  }
}
