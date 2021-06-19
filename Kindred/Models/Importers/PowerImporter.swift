//
//  PowerImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import CoreData
import SQLite

enum PowerImporter: Importer {
  
  static func importAll(context: NSManagedObjectContext) throws {
    guard let dbPath = Bundle.main.path(forResource: "reference", ofType: "sqlite") else {
      throw ImportError.databaseNotFound
    }
    let db = try Connection(dbPath, readonly: true)
    let powers = Table("powers")
    
    let name = Expression<String>("name")
    let disciplineName = Expression<String>("discipline")
    let level = Expression<Int>("level")
    let rouse = Expression<Int>("rouse")
    let pool = Expression<String?>("pool")
    let info = Expression<String>("info")
    let duration = Expression<String>("duration")
    let prerequisite = Expression<String?>("prerequisite")
    let source = Expression<Int>("source")
    let page = Expression<Int>("page")
    
    for row in try db.prepare(powers) {
      let power = Power(context: context)
      power.name = row[name]
      power.level = Int16(row[level])
      power.rouse = Int16(row[rouse])
      power.pool = row[pool]
      power.info = row[info]
      power.duration = row[duration]
      power.prerequisite = row[prerequisite]
      power.source = Int16(row[source])
      power.page = Int16(row[page])
      
      // Get the disciplines
      let disciplineName = row[disciplineName]
      guard let discipline = Discipline.fetchObject(named: disciplineName, in: context) else {
        throw ImportError.invalidReference("\(disciplineName) is not a valid Discipline!")
      }
      power.discipline = discipline
    }
  }
  
}
