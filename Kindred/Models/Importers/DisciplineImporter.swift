//
//  DisciplineImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import CoreData
import SQLite

enum DisciplineImporter: Importer {
  
  static func importAll(after currentVersion: Int, context: NSManagedObjectContext) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let version = Expression<Int>("version")
    let disciplines = Table("disciplines").filter(version > currentVersion)
    
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let resonance = Expression<String>("resonance")
    let icon = Expression<String>("icon")
    let refID = Expression<Int>("refID")
    
    for row in try db.prepare(disciplines) {
      let refID = Int16(row[refID])
      let discipline = Discipline.fetchItem(id: refID, in: context) ?? Discipline(context: context)
      
      discipline.name = row[name]
      discipline.info = row[info]
      discipline.resonance = row[resonance]
      discipline.icon = row[icon]
      discipline.refID = refID
    }
  }
  
}
