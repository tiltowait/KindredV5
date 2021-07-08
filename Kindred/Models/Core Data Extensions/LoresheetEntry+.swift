//
//  LoresheetEntry+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/6/21.
//

import CoreData

extension LoresheetEntry {
  
  static var sortedFetchRequest: NSFetchRequest<LoresheetEntry> {
    let request: NSFetchRequest<LoresheetEntry> = LoresheetEntry.fetchRequest()
    request.sortDescriptors = [
      NSSortDescriptor(keyPath: \LoresheetEntry.level, ascending: true),
      NSSortDescriptor(keyPath: \LoresheetEntry.zName, ascending: true)
    ]
    return request
  }
  
}

extension LoresheetEntry: Comparable {
  
  public static func < (lhs: LoresheetEntry, rhs: LoresheetEntry) -> Bool {
    lhs.level < rhs.level
  }
  
}
