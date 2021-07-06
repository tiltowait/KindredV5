//
//  InfoItem+.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/25/21.
//

import CoreData

// Convenience accessors for InfoItems

extension InfoItem {
  
  /// The item's name.
  var name: String {
    get { zName! }
    set { zName = newValue }
  }
  
  /// The item's flavor text/description.
  var info: String {
    get { zInfo! }
    set { zInfo = newValue }
  }
  
  /// Fetch an item with a given reference ID.
  /// - Parameters:
  ///   - id: The reference ID of the item to fetch.
  ///   - context: The managed object context containing the referenced item.
  /// - Returns: The fetched item, or nil if no item with that reference ID exists.
  static func fetchItem(id: Int16, in context: NSManagedObjectContext) -> Self? {
    let className = NSStringFromClass(Self.self)
    let request = NSFetchRequest<Self>(entityName: className)
    request.predicate = NSPredicate(format: "refID = %d", id)
    request.fetchLimit = 1
    
    return try? context.fetch(request).first
  }
  
}
