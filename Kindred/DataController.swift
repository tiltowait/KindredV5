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
  
  /// Every single `Advantage` and associated options in the database, sorted alphabetically.
  private(set) lazy var advantages: [Advantage] = {
    do {
      let advantages = try container.viewContext.fetch(Advantage.sortedFetchRequest)
      return advantages
    } catch {
      fatalError("Unable to fetch advantages.\n\(error.localizedDescription)")
    }
  }()
  
  /// Every single `AdvantageOption` in the database, sorted by value and name.
  private(set) lazy var advantageOptions: [AdvantageOption] = {
    do {
      let options = try container.viewContext.fetch(AdvantageOption.sortedFetchRequest)
      return options
    } catch {
      fatalError("Unable to fetch advantage options.\n\(error.localizedDescription)")
    }
  }()
  
  /// Every `Loresheet` and associated entry in the database, sorted alphabetically.
  private(set) lazy var loresheets: [Loresheet] = {
    do {
      let loresheets = try container.viewContext.fetch(Loresheet.sortedFetchRequest)
      return loresheets
    } catch {
      fatalError("Unable to fetch loresheets.\n\(error.localizedDescription)")
    }
  }()
  
  /// Every `LoresheetEntry` in the database, sorted by value and name.
  private(set) lazy var loresheetEntries: [LoresheetEntry] = {
    do {
      let entries = try container.viewContext.fetch(LoresheetEntry.sortedFetchRequest)
      return entries
    } catch {
      fatalError("Unable to fetch loresheet entries.\n\(error.localizedDescription)")
    }
  }()
  
  private(set) lazy var traitReference: [String: String] = {
    guard let url = Bundle.main.url(forResource: "TraitReference", withExtension: "plist"),
          let traitReference = NSDictionary(contentsOf: url) as? [String: String]
    else { return [:] }
    
    return traitReference
  }()
  
  private lazy var sqliteReferenceVersion: Int = {
    let db = try? Connection(Global.referenceDatabasePath, readonly: true)
    let table = Table("current_version")
    let column = Expression<Int>("version")
    
    guard let version = try? db?.scalar(table.select(column.max)) else {
      fatalError("Unable to fetch the reference database version.")
    }
    return version
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
    let coreDataReferenceVersion = UserDefaults.standard.integer(forKey: Global.referenceVersionKey)
    
    if coreDataReferenceVersion < self.sqliteReferenceVersion {
      print("Fetching new items")
      do {
        try DisciplineImporter.importAll(after: coreDataReferenceVersion, context: container.viewContext)
        try PowerImporter.importAll(after: coreDataReferenceVersion, context: container.viewContext)
        try ClanImporter.importAll(after: coreDataReferenceVersion, context: container.viewContext)
        try AdvantageImporter.importAll(after: coreDataReferenceVersion, context: container.viewContext)
        try AdvantageOptionImporter.importAll(after: coreDataReferenceVersion, context: container.viewContext)
        try LoresheetImporter.importAll(after: coreDataReferenceVersion, context: container.viewContext)
        
        self.save()
        
      } catch ImportError.invalidReference(let object) {
        fatalError(object)
      } catch {
        fatalError(error.localizedDescription)
      }
      UserDefaults.standard.set(sqliteReferenceVersion, forKey: Global.referenceVersionKey)
    }
    
    #if DEBUG
    let powerCount = try! container.viewContext.count(for: Power.allPowersFetchRequest)
    
    print("Stored version: \(coreDataReferenceVersion)")
    print("SQLite version: \(sqliteReferenceVersion)")
    
    print("\n\(disciplines.count) disciplines")
    print("\tWith \(powerCount) powers")
    print("\(clans.count) clans")
    print("\(advantages.count) advantages")
    print("\tWith \(advantageOptions.count) options")
    print("\(loresheets.count) loresheets")
    print("\tWith \(loresheetEntries.count) entries")
    #endif
    
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

