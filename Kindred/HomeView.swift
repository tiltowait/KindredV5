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
      KindredList()
        .tag(Tab.kindred)
        .tabItem {
          Image(systemName: "person.3")
          Text("Characters")
        }
      ReferenceView()
        .tag(Tab.reference)
        .tabItem {
          Image(systemName: "books.vertical")
          Text("Reference")
        }
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
