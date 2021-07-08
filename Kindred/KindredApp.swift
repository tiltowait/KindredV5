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
//    let dataController = DataController.preview
    let dataController = DataController(inMemory: false)
    _dataController = StateObject(wrappedValue: dataController)
  }
  
  var body: some Scene {
    WindowGroup {
      HomeView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
        .onReceive(
          // Automatically save when we detect we are no longer the foreground app. Use this rather
          // than scene phase API so we can port to macOS, where scene phase won't detect our app
          // losing focus as of macOS 11.1.
          NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
          perform: save
        )
    }
  }
  
  func save(_ note: Notification) {
    dataController.save()
  }
  
}
