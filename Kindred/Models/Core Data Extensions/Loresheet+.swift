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
  
}
