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
  }
  
  @SceneStorage("selectedView") var selectedView = Tab.kindred
  
  var body: some View {
    TabView(selection: $selectedView) {
      CharacterList()
        .tag(Tab.kindred)
        .tabItem {
          Label("Characters", systemImage: "person.3")
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
  }
}
