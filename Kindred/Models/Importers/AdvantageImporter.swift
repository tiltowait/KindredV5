//
//  AdvantageImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import CoreData
import SQLite

enum AdvantageImporter: Importer {
  
  static func importAll(after currentVersion: Int, context: NSManagedObjectContext) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let version = Expression<Int>("version")
    let advantages = Table("advantages").filter(version > currentVersion)
    
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let isBackground = Expression<Int>("background")
    let refID = Expression<Int>("refID")
    
    for row in try db.prepare(advantages) {
      let refID = Int16(row[refID])
      let advantage = Advantage.fetchItem(id: refID, in: context) ?? Advantage(context: context)
      
      advantage.name = row[name]
      advantage.info = row[info]
      advantage.isBackground = row[isBackground] == 1
      advantage.refID = refID
    }
  }
  
}
