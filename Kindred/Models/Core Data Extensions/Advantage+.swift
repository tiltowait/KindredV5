//
//  Advantage+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import CoreData

extension Advantage {
  
  static var sortedFetchRequest: NSFetchRequest<Advantage> {
    let request: NSFetchRequest<Advantage> = Advantage.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Advantage.zName, ascending: true)]
    return request
  }
  
  var allOptions: [AdvantageOption] {
    let options = self.options as? Set<AdvantageOption>
    return options?.sorted() ?? []
  }
  
}
