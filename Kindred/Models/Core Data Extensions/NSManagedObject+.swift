//
//  NSManagedObject+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import CoreData

extension NSManagedObject {
  
  var className: String {
    NSStringFromClass(type(of: self))
  }
  
  static func fetch<T: NSManagedObject>(_ type: T.Type, named name: String, in context: NSManagedObjectContext) -> T? {
    let className = NSStringFromClass(T.self)
    print(className)
    let request: NSFetchRequest<T> = NSFetchRequest(entityName: className)
    request.predicate = NSPredicate(format: "name = %@", name)
    request.fetchLimit = 1
    
    return try? context.fetch(request).first
  }
  
  static func fetchObject(named name: String, in context: NSManagedObjectContext) -> Self? {
    let className = NSStringFromClass(Self.self)
    
    let request: NSFetchRequest<Self> = NSFetchRequest(entityName: className)
    request.predicate = NSPredicate(format: "zName = %@", name)
    request.fetchLimit = 1
    
    return try? context.fetch(request).first
  }
  
}
