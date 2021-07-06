//
//  AdvantageImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import CoreData
import SQLite

enum AdvantageImporter: Importer {
  
  static func importAll(context: NSManagedObjectContext) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let advantages = Table("advantages")
    
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let isBackground = Expression<Int>("background")
    
    for row in try db.prepare(advantages) {
      let advantage = Advantage(context: context)
      advantage.name = row[name]
      advantage.info = row[info]
      advantage.isBackground = row[isBackground] == 1
    }
  }
  
}
