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
  
  // TODO: Remove these lazy variables and have the appropriate view models manage them.
  
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
  
  /// Every `Loresheet` and associated entry in the database, sorted alphabetically.
  private(set) lazy var loresheets: [Loresheet] = {
    do {
      let loresheets = try container.viewContext.fetch(Loresheet.sortedFetchRequest)
      return loresheets
    } catch {
      fatalError("Unable to fetch loresheets.\n\(error.localizedDescription)")
    }
  }()
  
  /// A dictionary of traits-as-keys and descriptions of what they are used for.
  private(set) lazy var traitReference: [String: String] = {
    guard let url = Bundle.main.url(forResource: "TraitReference", withExtension: "plist"),
          let traitReference = NSDictionary(contentsOf: url) as? [String: String]
    else { return [:] }
    
    return traitReference
  }()
  
  // MARK: - Database Members
  /// The highest revision number in the SQLite reference database.
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
  
  // MARK: - Methods
  
  /// Creates a `DataController` and initializes reference data if the store is empty.
  /// - Parameter inMemory: Set to `true` if the data should not persist across launches. Default `false`.
  init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
    container = NSPersistentCloudKitContainer(name: "KindredModel", managedObjectModel: Self.model)
    self.defaults = defaults
    
    // Load up reference material
    
    
    
    if inMemory {
      print("Running in memory! Data will not persist.")
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Unable to load persistent store.\n\(error.localizedDescription)")
      }
    }
    // In prior versions, before adding CloudKit, we used UserDefaults to track the reference
    // database version. However, CloudKit means that users can load new reference material on
    // another device, so we will store the reference version in our Core Data model instead. To
    // make things easier for existing users, we convert for them.
    
    let cdVersion = self.fetchAll(CDReferenceVersion.self).first ?? CDReferenceVersion(context: container.viewContext)
    let udReferenceVersion = defaults.integer(forKey: Global.referenceVersionKey)
    
    if !inMemory && udReferenceVersion > cdVersion.version {
      print("Establishing CDReferenceVersion")
      cdVersion.version = Int16(udReferenceVersion)
      defaults.set(-1, forKey: Global.referenceVersionKey) // Make it so we never overwrite again
      self.save()
    }

        
    // Each importer reads only those reference items that have a revision number higher than the
    // Core Data version number stored in user defaults. For each row in the reference database,
    // the importers first try to fetch an object with that row's reference ID; if they can't, then
    // they create a new item with that ID.
    
    if cdVersion.version < self.sqliteReferenceVersion {
      print("Fetching new items")
      let oldVersion = 1 //Int(cdVersion.version)
      do {
        try DisciplineImporter.importAll(after: oldVersion, context: container.viewContext)
        try ClanImporter.importAll(after: oldVersion, context: container.viewContext)
        try AdvantageImporter.importAll(after: oldVersion, context: container.viewContext)
        try LoresheetImporter.importAll(after: oldVersion, context: container.viewContext)
        try RitualImporter.importAll(after: oldVersion, context: container.viewContext)
        
        cdVersion.version = Int16(sqliteReferenceVersion)
        self.save()
        
      } catch ImportError.invalidReference(let object) {
        fatalError(object)
      } catch {
        fatalError(error.localizedDescription)
      }
      defaults.set(sqliteReferenceVersion, forKey: Global.referenceVersionKey)
    }
    
    removeDuplicates()
    
    #if DEBUG
    print("Stored version: \(udReferenceVersion)")
    print("SQLite version: \(sqliteReferenceVersion)")
    
    print("\n\(self.countAll(Discipline.self)) disciplines")
    print("\tWith \(self.countAll(Power.self)) powers")
    print("\(self.countAll(Clan.self)) clans")
    print("\(self.countAll(Advantage.self)) advantages")
    print("\tWith \(self.countAll(AdvantageOption.self)) options")
    print("\(self.countAll(Loresheet.self)) loresheets")
    print("\tWith \(self.countAll(LoresheetEntry.self)) entries")
    print("\(self.countAll(Ritual.self)) rituals")
    #endif
    
  }
  
  private func removeDuplicates() {
    do {
      try LoresheetImporter.removeDuplicates(in: container.viewContext)
      try RitualImporter.removeDuplicates(in: container.viewContext)
      try DisciplineImporter.removeDuplicates(in: container.viewContext)
      try ClanImporter.removeDuplicates(in: container.viewContext)
      try AdvantageImporter.removeDuplicates(in: container.viewContext)
    } catch {
      print(error.localizedDescription)
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
  
  func isPurchased(item: ReferenceItem) -> Bool {
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

