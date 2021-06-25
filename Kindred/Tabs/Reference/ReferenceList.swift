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
  }
  
  var body: some View {
    NavigationView {
      List {
        Section(footer: footer) {
          NavigationLink(destination: AdvantageList(dataController: dataController)) {
            Text("Advantages")
              .font(.subheadline)
          }
          
          NavigationLink(destination:
                          DisciplineList()) {
            Text("Disciplines")
              .font(.subheadline)
          }
          
          NavigationLink(destination: ClanList(dataController: dataController)) {
            Text("Clans")
              .font(.subheadline)
          }
        }
      }
      .navigationTitle("Reference")
      .listStyle(InsetGroupedListStyle())
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
