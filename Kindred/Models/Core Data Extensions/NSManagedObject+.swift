//
//  NSManagedObject+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import CoreData

extension NSManagedObject {
  
  static func fetchObject(named name: String, in context: NSManagedObjectContext) -> Self? {
    let request = Self.fetchRequest()
    request.predicate = NSPredicate(format: "zName like[cd] %@", name) // Case-insensitive; ignore diacritics
    request.fetchLimit = 1
    
    return (try? context.fetch(request).first) as? Self
  }
  
}
