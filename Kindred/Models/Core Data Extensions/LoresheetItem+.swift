//
//  LoresheetItem+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/6/21.
//

import CoreData

extension LoresheetItem {
  
  static var sortedFetchRequest: NSFetchRequest<LoresheetItem> {
    let request: NSFetchRequest<LoresheetItem> = LoresheetItem.fetchRequest()
    request.sortDescriptors = [
      NSSortDescriptor(keyPath: \LoresheetItem.level, ascending: true),
      NSSortDescriptor(keyPath: \LoresheetItem.zName, ascending: true)
    ]
    return request
  }
  
}
