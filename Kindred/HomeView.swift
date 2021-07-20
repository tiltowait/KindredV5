//
//  HomeView.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/20/21.
//

import SwiftUI

struct HomeView: View {
  
  enum Tab: String {
    case kindred
    case reference
    case diceRoller
  }
  
  @SceneStorage("selectedView") var selectedView = Tab.kindred
  @EnvironmentObject var dataController: DataController
  
  var body: some View {
    TabView(selection: $selectedView) {
      CharacterList(dataController: dataController)
        .tag(Tab.kindred)
        .tabItem {
          Label("Characters", systemImage: "person.3")
        }
      
      DiceRoller()
        .tag(Tab.diceRoller)
        .tabItem {
          Label("Dice", systemImage: "diamond.fill")
        }
      
      ReferenceList()
        .tag(Tab.reference)
        .tabItem {
          Label("Reference", systemImage: "books.vertical")
        }
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
      .environmentObject(DataController.preview)
      .environment(\.managedObjectContext, DataController.preview.container.viewContext)
  }
}
