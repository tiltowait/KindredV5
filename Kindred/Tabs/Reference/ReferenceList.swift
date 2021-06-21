//
//  ReferenceList.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/25/21.
//

import SwiftUI

struct ReferenceList: View {
  
  @EnvironmentObject var dataController: DataController
  
  var body: some View {
    NavigationView {
      List {
        
        NavigationLink(destination: AdvantageList(dataController: dataController)) {
          Text("Advantages")
        }
        
        NavigationLink(destination:
          DisciplineList()) {
          Text("Disciplines")
        }
        
        NavigationLink(destination: ClanList(dataController: dataController)) {
          Text("Clans")
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
      .environmentObject(DataController.preview)
  }
}
