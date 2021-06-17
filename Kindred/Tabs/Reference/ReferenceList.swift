//
//  ReferenceList.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/25/21.
//

import SwiftUI

struct ReferenceList: View {
  
  var body: some View {
    NavigationView {
      List {
        NavigationLink(destination:
          DisciplineList()) {
          Text("Disciplines")
        }
      }
      .font(.headline)
      .navigationTitle("Reference")
    }
  }
  
}

struct ReferenceView_Previews: PreviewProvider {
  static var previews: some View {
    ReferenceList()
      .environment(\.managedObjectContext, DataController.preview.container.viewContext)
  }
}
