//
//  DisciplineList.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/25/21.
//

import SwiftUI

struct DisciplineList: View {
  
  var body: some View {
    List(ReferenceManager.shared.disciplines) { discipline in
      NavigationLink(destination: DisciplineDetail(discipline: discipline, kindred: nil)) {
        DisciplineRow(discipline: discipline)
      }
    }
    .listStyle(.insetGrouped)
    .navigationTitle("Disciplines")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct DisciplineList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DisciplineList()
        .environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
  }
}
