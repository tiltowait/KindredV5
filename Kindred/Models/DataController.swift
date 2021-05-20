//
//  DataController.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/20/21.
//

import Foundation
import CoreData

class DataController {
  
  let container: NSPersistentCloudKitContainer
  
  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "KindredModel")
    
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores { storeDescription, error in
      if let error = error {
        fatalError("Unable to load persistent store.\n\(error.localizedDescription)")
      }
    }
    
    // Load up reference material
    if self.isEmpty {
      let disciplineFactory = DisciplineFactory(context: container.viewContext)
      _ = disciplineFactory.fetchAll()
      
      self.save()
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
    do {
      try container.viewContext.save()
    } catch {
      fatalError("Unable to save data.\n\(error.localizedDescription)")
    }
  }
  
}
