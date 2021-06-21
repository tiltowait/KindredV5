//
//  DisciplineImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import CoreData
import SQLite

enum DisciplineImporter: Importer {
  
  static func importAll(context: NSManagedObjectContext) throws {
    guard let dbPath = Global.dbPath else {
      throw ImportError.databaseNotFound
    }
    let db = try Connection(dbPath, readonly: true)
    let disciplines = Table("disciplines")
    
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let resonance = Expression<String>("resonance")
    let icon = Expression<String>("icon")
    
    for row in try db.prepare(disciplines) {
      let discipline = Discipline(context: context)
      discipline.name = row[name]
      discipline.info = row[info]
      discipline.resonance = row[resonance]
      discipline.icon = row[icon]
    }
  }
  
}
