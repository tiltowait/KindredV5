//
//  DisciplineImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import CoreData
import SQLite

/// A data importer responsible for importing `Discipline`s and associated `Power`s.
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
    
    try Self.importPowers(after: currentVersion, context: context)
  }
  
  private static func importPowers(after currentVersion: Int, context: NSManagedObjectContext) throws {
    print("Importing Powers")
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let version = Expression<Int>("version")
    let powers = Table("powers").filter(version > currentVersion)
    
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
    let refID = Expression<Int>("refID")
    
    for row in try db.prepare(powers) {
      let refID = Int16(row[refID])
      let power = Power.fetchItem(id: refID, in: context) ?? Power(context: context)
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
      power.refID = refID
    }
  }
  
}
