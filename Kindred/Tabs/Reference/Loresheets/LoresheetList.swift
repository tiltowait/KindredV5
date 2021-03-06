//
//  LoresheetList.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import SwiftUI

struct LoresheetList: View {
  @EnvironmentObject var dataController: DataController
  @State private var lockedIdentifier: String?
  
  var body: some View {
    List(ReferenceManager.shared.loresheets) { loresheet in
      row(loresheet: loresheet)
    }
    .listStyle(.insetGrouped)
    .navigationTitle("Loresheets")
    .navigationBarTitleDisplayMode(.inline)
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
          unlocked: false
        )
        .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
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
