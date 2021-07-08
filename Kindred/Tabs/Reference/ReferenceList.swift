//
//  ReferenceList.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/25/21.
//

import SwiftUI

struct ReferenceList: View {
  
  @EnvironmentObject var dataController: DataController
  
  var footer: some View {
      Text("Vampire: The Masquerade and World of Darkness are copyright © Paradox Interactive.")
        .multilineTextAlignment(.center)
        .padding(.top)
        .centered()
  }
  
  var body: some View {
    NavigationView {
      List {
        Section { } // Empty section for spacing
        
        Section(footer: footer) {
          NavigationLink(destination: AdvantageList(dataController: dataController)) {
            Text("Advantages")
              .font(.headline)
          }
          NavigationLink(destination:
                          DisciplineList()) {
            Text("Disciplines")
              .font(.headline)
          }
          NavigationLink(destination: ClanList(dataController: dataController)) {
            Text("Clans")
              .font(.headline)
          }
          NavigationLink(destination: LoresheetList()) {
            Text("Loresheets")
              .font(.headline)
          }
        }
      }
      .navigationTitle("Reference")
      .listStyle(InsetGroupedListStyle())
      
      Text("Select an item on the left.")
        .foregroundColor(.secondary)
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
