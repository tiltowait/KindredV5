//
//  CloudDefaults.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/15/22.
//

import Foundation

final class CloudDefaults {
  static let shared = CloudDefaults()
  private var ignoreLocalChanges = false
  private let keyPrefix = "com.tiltowait.Kindred"
  
  private init() { }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func start() {
    NotificationCenter.default.addObserver(forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default, queue: .main, using: updateLocal)
    NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main, using: updateRemote)
    NSUbiquitousKeyValueStore.default.synchronize()
  }
  
  private func updateRemote(note: Notification) {
    guard ignoreLocalChanges == false else { return }
    
    for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
      guard key.hasPrefix(keyPrefix) else { continue }
      print("Updating remote value of \(key) to \(value)")
      NSUbiquitousKeyValueStore.default.set(value, forKey: key)
    }
  }
  
  private func updateLocal(note: Notification) {
    ignoreLocalChanges = true
    
    for (key, value) in NSUbiquitousKeyValueStore.default.dictionaryRepresentation {
      guard key.hasPrefix(keyPrefix) else { continue }
      print("Updating local value of \(key) to \(value)")
      UserDefaults.standard.set(value, forKey: key)
    }
    
    ignoreLocalChanges = false
  }
}
