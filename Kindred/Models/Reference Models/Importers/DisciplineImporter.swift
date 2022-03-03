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
  
  static func importAll<T: InfoItem>(of type: T.self) -> [T] throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let disciplines = Table("disciplines")
    
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let resonance = Expression<String>("resonance")
    let icon = Expression<String>("icon")
    let refID = Expression<Int>("refID")
    
    var allDisciplines: [Discipline] = []
    
    for row in try db.prepare(disciplines) {
      let refID = Int16(row[refID])
      let discipline = Discipline(
        id: refID,
        name: row[name],
        info: row[info],
        icon: row[icon],
        resonance: row[resonance],
      )
      try Self.importPowers(for: discipline)
      allDisciplines.append(discipline)
    }
    
    return allDisciplines
  }
  
  private static func importPowers(for discipline: Discipline) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
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
    let refID = Expression<Int>("refID")
    
    for row in try db.prepare(powers) {
      let refID = Int16(row[refID])
      let power = Power(
        id: refID,
        name: row[name],
        info: row[info],
        page: Int16(row[page]),
        source: Int16(row[source]),
        powerDuration: row[duration],
        level: Int16(row[level]),
        pool: row[pool],
        rouse: Int16(row[rouse]),
        prerequisites: row[prerequisite],
        discipline: discipline
      )
    }
  }
}
