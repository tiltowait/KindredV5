//
//  KindredApp.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/20/21.
//

import SwiftUI

@main
struct KindredApp: App {
  
  @StateObject var dataController: DataController
  
  init() {
    let dataController = DataController(inMemory: false)
//    let dataController = DataController(inMemory: true)

    _dataController = StateObject(wrappedValue: dataController)
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
    }
  }
  
}
