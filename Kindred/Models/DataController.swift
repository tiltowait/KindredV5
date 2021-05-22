//
//  DataController.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/20/21.
//

import Foundation
import CoreData

class DataController: ObservableObject {
  private(set) var disciplines: [Discipline]!
  
  let container: NSPersistentCloudKitContainer
  
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
      print("Empty container. Populating.")
      let disciplineFactory = DisciplineFactory(context: container.viewContext)
      disciplines = disciplineFactory.fetchAll()
      
      self.save()
    }
    
    for power in disciplines.first!.allPowers {
      print(power)
    }
  }
  
  private var isEmpty: Bool {
    let request: NSFetchRequest<Discipline> = Discipline.fetchRequest()
    do {
      let disciplines = try container.viewContext.fetch(request)
      return disciplines.isEmpty
    } catch {
      fatalError("Unable to test core data storage.")
    }
  }
  
  func save() {
    if container.viewContext.hasChanges {
      try? container.viewContext.save()
    }
  }
  
  func delete(_ object: NSManagedObject) {
    container.viewContext.delete(object)
  }
  
}
