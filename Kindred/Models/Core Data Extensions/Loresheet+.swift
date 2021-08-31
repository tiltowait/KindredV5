//
//  Loresheet+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/6/21.
//

import CoreData

extension Loresheet {
  
  static var sortedFetchRequest: NSFetchRequest<Loresheet> {
    let request: NSFetchRequest<Loresheet> = Loresheet.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Loresheet.zName, ascending: true)]
    return request
  }
  
  var entries: [LoresheetEntry] {
    self.items?.array as? [LoresheetEntry] ?? []
  }
  
  var clanRestrictions: [Clan]? {
    let restrictions = self.requiredClans?.allObjects as? [Clan]
    return restrictions?.sorted { $0.name < $1.name }
  }
  
}

extension Loresheet: Comparable {
  
  public static func <(lhs: Loresheet, rhs: Loresheet) -> Bool {
    lhs.name < rhs.name
  }
  
}
