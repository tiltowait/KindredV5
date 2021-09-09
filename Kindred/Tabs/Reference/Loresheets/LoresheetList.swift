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
  @EnvironmentObject var dataController: DataController
  
  @State private var lockedIdentifier: String?
  
  var body: some View {
    List(loresheets) { loresheet in
      row(loresheet: loresheet)
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarTitle("Loresheets", displayMode: .inline)
    .sheet(item: $lockedIdentifier) { item in
      UnlockView(highlights: [item])
    }
    .onChange(of: lockedIdentifier) { value in
      // Notify the view to redraw in case we made a purchase
      dataController.objectWillChange.send()
    }
  }
  
  @ViewBuilder func row(loresheet: Loresheet) -> some View {
    if dataController.isPurchased(item: loresheet) {
      NavigationLink(destination: LoresheetDetail(loresheet: loresheet)) {
        ReferenceRow(
          loresheet.name,
          secondary: loresheet.pageReference
        )
      }
    } else {
      Button {
        lockedIdentifier = loresheet.unlockIdentifier
      } label: {
        ReferenceRow(
          loresheet.name,
          secondary: loresheet.pageReference,
          color: loresheet.sourceBook.color,
          unlocked: false
        )
        .contentShape(Rectangle())
      }
      .buttonStyle(PlainButtonStyle())
    }
  }
  
}

struct LoresheetList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      LoresheetList()
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
        .environmentObject(DataController.preview)
    }
  }
}
