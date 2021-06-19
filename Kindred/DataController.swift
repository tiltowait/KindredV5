//
//  DataController.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/20/21.
//

import Foundation
import CoreData

class DataController: ObservableObject {
  
  /// The primary Core Data container.
  let container: NSPersistentCloudKitContainer
  
  /// Shared data controller used for SwiftUI previews.
  ///
  /// It is necessary to keep this shared instance in the main class, because it is the only way to ensure
  /// that all preview data uses the same managed object context.
  static let preview = DataController(inMemory: true)
  
  /// Every single `Clan`, sorted alphabetically.
  private(set) lazy var clans: [Clan] = {
    do {
      let clans = try container.viewContext.fetch(Clan.sortedFetchRequest)
      return clans
    } catch {
      fatalError("Unable to fetch clans.\n\(error.localizedDescription)")
    }
  }()
  
  /// Every single `Discipline` (and associated `Power`s) in the database, sorted alphabetically.
  private(set) lazy var disciplines: [Discipline] = {
    do {
      let disciplines = try container.viewContext.fetch(Discipline.sortedFetchRequest)
      return disciplines
    } catch {
      fatalError("Unable to fetch disciplines.\n\(error.localizedDescription)")
    }
  }()
  
  private(set) lazy var traitReference: [String: String] = {
    guard let url = Bundle.main.url(forResource: "TraitReference", withExtension: "plist"),
          let traitReference = NSDictionary(contentsOf: url) as? [String: String]
    else { return [:] }
    
    return traitReference
  }()
  
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
  
  /// Creates a `DataController` and initializes reference data if the store is empty.
  /// - Parameter inMemory: Set to `true` if the data should not persist across launches. Default `false`.
  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "KindredModel", managedObjectModel: Self.model)
    
    if inMemory {
      print("Running in memory! Data will not persist.")
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Unable to load persistent store.\n\(error.localizedDescription)")
      }
    }
    
    // Load up reference material
    if self.isEmpty {
      DisciplineFactory.loadAll(context: container.viewContext)
      ClanFactory.loadAll(context: container.viewContext, disciplines: self.disciplines)
      
      #if DEBUG
      let powerCount = try! container.viewContext.count(for: Power.allPowersFetchRequest)
      
      print("Empty container. Populating ...")
      print("\tLoaded \(disciplines.count) disciplines")
      print("\t\tWith \(powerCount) powers")
      print("\tLoaded \(clans.count) clans")
      #endif
      
      self.save()
    }
  }
  
  /// `True` if the data store is empty.
  private var isEmpty: Bool {
    let request: NSFetchRequest<Discipline> = Discipline.fetchRequest()
    do {
      let disciplines = try container.viewContext.fetch(request)
      return disciplines.isEmpty
    } catch {
      fatalError("Unable to test core data storage.")
    }
  }
  
  /// Retrieve a Clan by name.
  /// - Parameter name: The name of the Clan to retrieve.
  /// - Returns: The clan, or nil if not found.
  func clan(named name: String) -> Clan? {
    clans.first { $0.name == name }
  }
  
  /// Fetches all objects matching a particular request.
  /// - Parameter request: The request.
  /// - Returns: The objects matching the request.
  func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
    (try? container.viewContext.fetch(request)) ?? []
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
  
}

