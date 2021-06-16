//
//  ContentView.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/20/21.
//

import SwiftUI

struct ContentView: View {
  
  @SceneStorage("selectedView") var selectedView: String?
  
  var body: some View {
    TabView(selection: $selectedView) {
      KindredListView()
        .tag(KindredListView.tag)
        .tabItem {
          Image(systemName: "person.3")
          Text("Characters")
        }
      ReferenceView()
        .tag(ReferenceView.tag)
        .tabItem {
          Image(systemName: "books.vertical")
          Text("Reference")
        }
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
