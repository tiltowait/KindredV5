//
//  RitualImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/27/21.
//

import CoreData
import SQLite

enum RitualImporter: Importer {
  
  static func importAll(after currentVersion: Int, context: NSManagedObjectContext) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let version = Expression<Int>("version")
    let rituals = Table("rituals").filter(version > currentVersion)
    
    let name = Expression<String>("name")
    let level = Expression<Int>("level")
    let info = Expression<String>("info")
    let ingredients = Expression<String?>("ingredients")
    let process = Expression<String>("process")
    let system = Expression<String>("system")
    let duration = Expression<String?>("duration")
    let source = Expression<Int>("source")
    let page = Expression<Int>("page")
    let prerequisite = Expression<String?>("prerequisite")
    let discipline = Expression<String>("discipline")
    let refID = Expression<Int>("refID")

    for row in try db.prepare(rituals) {
      let refID = Int16(row[refID])
      let ritual = Ritual.fetchItem(id: refID, in: context) ?? Ritual(context: context)

      ritual.name = row[name]
      ritual.level = Int16(row[level])
      ritual.info = row[info]
      ritual.ingredients = row[ingredients]
      ritual.process = row[process]
      ritual.system = row[system]
      ritual.duration = row[duration]
      ritual.source = Int16(row[source])
      ritual.page = Int16(row[page])
      ritual.refID = refID
      
      if let prerequisite = row[prerequisite] {
        // Ritual has a prerequisite power. This is currently only the case for Oblivion ceremonies.
        guard let power = Power.fetchObject(named: prerequisite, in: context) else {
          throw ImportError.invalidReference("\(prerequisite) is not a valid power.")
        }
        ritual.prerequisite = power
      }
      
      let disciplineName = row[discipline]
      guard let discipline = Discipline.fetchObject(named: disciplineName, in: context) else {
        throw ImportError.invalidReference("\(disciplineName) is not a valid discipline.")
      }
      ritual.discipline = discipline
    }
  }
  
}
