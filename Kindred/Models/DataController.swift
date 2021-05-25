//
//  DataController.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/20/21.
//

import Foundation
import CoreData

class DataController: ObservableObject {
  
  let container: NSPersistentCloudKitContainer
  
  /// Static `DataController` used for SwiftUI previews.
  static let preview = DataController(inMemory: true)
  
  /// Every single `Discipline` (and associated `Power`s) in the database, sorted alphabetically.
  private(set) lazy var disciplines: [Discipline] = {
    do {
      let disciplines = try container.viewContext.fetch(Discipline.sortedFetchRequest)
      return disciplines
    } catch {
      fatalError("Unable to fetch disciplines.\n\(error.localizedDescription)")
    }
  }()
  
  /// Creates a `DataController` and initializes reference data if the store is empty.
  /// - Parameter inMemory: Set to `true` if the data should not persist across launches. Default `false`.
  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "KindredModel")
    
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
      
      #if DEBUG
      let powerCount = try! container.viewContext.count(for: Power.allPowersFetchRequest)
      
      print("Empty container. Populating ...")
      print("\tLoaded \(disciplines.count) disciplines")
      print("\t\tWith \(powerCount) powers")
      #endif
      
      self.save()
    }
  }
  
  /// `True` if the data store is empty (technically, if it has no Disciplines).
  private var isEmpty: Bool {
    let request: NSFetchRequest<Discipline> = Discipline.fetchRequest()
    do {
      let disciplines = try container.viewContext.fetch(request)
      return disciplines.isEmpty
    } catch {
      fatalError("Unable to test core data storage.")
    }
  }
  
  /// Saves the data.
  func save() {
    if container.viewContext.hasChanges {
      try? container.viewContext.save()
    }
  }
  
  /// Deletes the user character from the store.
  /// - Parameter kindred: The character to delete.
  func delete(kindred: Kindred) {
    container.viewContext.delete(kindred)
    save()
  }
  
}

// MARK: - Preview Items
extension DataController {
  
  /// Example constants used for SwiftUI previews.
  enum Example {
    
    /// The example `Discipline` is Animalism.
    static let discipline: Discipline = {
      DataController.preview.disciplines[0]
    }()
    
    /// The example `Power` is Quell the Beast from Animalism.
    static let power: Power = {
      print("power")
      return DataController.Example.discipline.allPowers[4]
    }()
    
  }
  
}
