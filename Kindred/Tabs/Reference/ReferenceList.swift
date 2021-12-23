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
        Section(footer: footer) {
          NavigationLink(destination: AdvantageList(dataController: dataController)) {
            Text("Advantages")
              .font(.headline)
          }
          .isDetailLink(false)
          
          NavigationLink(destination: DisciplineList()) {
            Text("Disciplines")
              .font(.headline)
          }
          .isDetailLink(false)
          
          NavigationLink(destination: ClanList(dataController: dataController)) {
            Text("Clans")
              .font(.headline)
          }
          .isDetailLink(false)
          
          NavigationLink(destination: LoresheetList()) {
            Text("Loresheets")
              .font(.headline)
          }
          .isDetailLink(false)
          
          NavigationLink(
            destination: RitualList(
              flavor: .ritual,
              kindred: nil,
              dataController: dataController
            )
          ) {
            Text("Blood Sorcery Rituals")
              .font(.headline)
          }
          .isDetailLink(true)
          
          NavigationLink(
            destination: RitualList(
              flavor: .ceremony,
              kindred: nil,
              dataController: dataController
            )
          ) {
            Text("Oblivion Ceremonies")
              .font(.headline)
          }
          .isDetailLink(true)
          
          NavigationLink(
            destination: RitualList(
              flavor: .formula,
              kindred: nil,
              dataController: dataController
            )
          ) {
            Text("Thin-Blood Alchemy Formulae")
              .font(.headline)
          }
          .isDetailLink(true)
        }
      }
      .navigationTitle("Reference")
      
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
