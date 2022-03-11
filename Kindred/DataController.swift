//
//  DataController.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/20/21.
//

import Foundation
import CoreData
import SQLite

class DataController: ObservableObject {
  
  /// The primary Core Data container.
  let container: NSPersistentCloudKitContainer
  let defaults: UserDefaults
  
  /// Shared data controller used for SwiftUI previews.
  ///
  /// It is necessary to keep this shared instance in the main class, because it is the only way to ensure
  /// that all preview data uses the same managed object context.
  static let preview = DataController(inMemory: true)
  
  // MARK: - IAP Unlocks
  
  var purchaseIdentifiers: [String] {
    get {
      defaults.stringArray(forKey: "purchases") ?? []
    }
    set {
      defaults.set(newValue, forKey: "purchases")
    }
  }
  
  /// The user has unlocked unlimited characters.
  var unlockedUnlimited: Bool {
    self.purchaseIdentifiers.contains(unlockUnlimitedIdentifier)
  }
  
  var unlockUnlimitedIdentifier: String {
    "com.tiltowait.Kindred.unlimited"
  }
  
  // MARK: - Database Management
  
  /// A dictionary of traits-as-keys and descriptions of what they are used for.
  var traitReference: [String: String] {
    guard let url = Bundle.main.url(forResource: "TraitReference", withExtension: "plist"),
          let traitReference = NSDictionary(contentsOf: url) as? [String: String]
    else { return [:] }
    
    return traitReference
  }
  
  /// Static model file to prevent errors when testing.
  static let model: NSManagedObjectModel = {
    guard let url = Bundle.main.url(forResource: "KindredModel", withExtension: "momd") else {
      fatalError("Failed to load model file.")
    }
    guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Failed to load model file.")
    }
    return managedObjectModel
  }()
  
  // MARK: - Methods
  
  /// Creates a `DataController` and initializes reference data if the store is empty.
  /// - Parameter inMemory: Set to `true` if the data should not persist across launches. Default `false`.
  init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
    container = NSPersistentCloudKitContainer(name: "KindredModel", managedObjectModel: Self.model)
    self.defaults = defaults
    
    if inMemory {
      print("Running in memory! Data will not persist.")
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Unable to load persistent store.\n\(error.localizedDescription)")
      }
      self.container.viewContext.automaticallyMergesChangesFromParent = true
    }
  }
  
  /// Fetch all objects matching a particular request.
  ///
  /// If the request is malformed, this method will return an empty array.
  /// - Parameter request: The request.
  /// - Returns: The objects matching the request.
  func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
    (try? container.viewContext.fetch(request)) ?? []
  }
  
  /// Fetch all objects of a class.
  /// - Parameter type: The class of the object to fetch.
  /// - Returns: All objects of the particular class.
  func fetchAll<T: NSManagedObject>(_ type: T.Type) -> [T] {
    (try? container.viewContext.fetch(T.fetchRequest())) as? [T] ?? []
  }
  
  /// Count all objects of a class.
  /// - Parameter type: The class to count.
  /// - Returns: The number of objects contained in the datastore.
  func countAll<T: NSManagedObject>(_ type: T.Type) -> Int {
    (try? container.viewContext.count(for: T.fetchRequest())) ?? 0
  }
  
  /// Saves the data.
  func save() {
    if container.viewContext.hasChanges {
      try? container.viewContext.save()
    }
  }
  
  /// Deletes the user character from the store. Make sure to call `save()` afterward!
  /// - Parameter kindred: The character to delete.
  func delete(_ object: NSManagedObject) {
    container.viewContext.delete(object)
  }
  
  func purchase(identifier: String) {
    var purchases = self.purchaseIdentifiers
    purchases.append(identifier)
    self.purchaseIdentifiers = purchases
  }
  
  func isPurchased<T: ReferenceItem>(item: T) -> Bool {
    if item.unlockIdentifier == "included" {
      return true
    }
    return self.purchaseIdentifiers.contains(item.unlockIdentifier)
  }
  
  func isPurchased(identifier: String) -> Bool {
    if identifier == "included" {
      return true
    }
    return self.purchaseIdentifiers.contains(identifier)
  }
  
}

