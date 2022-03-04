//
//  RitualImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/27/21.
//

import CoreData
import SQLite

enum RitualImporter: Importer {
  
  static func importAll<T: InfoItem>(of type: T.Type) throws -> [T] {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let rituals = Table("rituals")
    
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
    
    var allRituals: [T] = []

    for row in try db.prepare(rituals) {
      let refID = Int16(row[refID])
      let prerequisitePower: Power?
      
      if let prereq = row[prerequisite] {
        // Ritual has a prerequisite power. This is currently only the case for Oblivion ceremonies.
        guard let power = ReferenceManager.shared.power(named: prereq) else {
          throw ImportError.invalidReference("\(prerequisite) is not a valid power.")
        }
        prerequisitePower = power
      } else {
        prerequisitePower = nil
      }
      
      let disciplineName = row[discipline]
      guard let discipline = ReferenceManager.shared.discipline(named: disciplineName) else {
        throw ImportError.invalidReference("\(disciplineName) is not a valid discipline.")
      }
      
      let ritual = Ritual(
        id: refID,
        name: row[name],
        info: row[info],
        page: Int16(row[page]),
        source: Int16(row[source]),
        duration: row[duration],
        ingredients: row[ingredients],
        level: Int16(row[level]),
        process: row[process],
        system: row[system],
        discipline: discipline,
        prerequisite: prerequisitePower
      )
      prerequisitePower?.dependentRituals.append(ritual)
      discipline.rituals.append(ritual)
      discipline.rituals.sort()
      allRituals.append(ritual as! T)
    }
    return allRituals
  }
}
