//
//  RitualImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/27/21.
//

import CoreData
import SQLite

enum RitualImporter: Importer {
  
  static func importAll<T: InfoItem>(of type: T.self) -> [T] throws {
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
    
    var allRituals: [Ritual] = []

    for row in try db.prepare(rituals) {
      let refID = Int16(row[refID])
      let prerequisite: Power?
      
      if let prerequisite = row[prerequisite] {
        // Ritual has a prerequisite power. This is currently only the case for Oblivion ceremonies.
        guard let power = Power.fetchObject(named: prerequisite, in: context) else {
          throw ImportError.invalidReference("\(prerequisite) is not a valid power.")
        }
        prerequisite = power
      } else {
        prerequisite = nil
      }
      
      let disciplineName = row[discipline]
      guard let discipline = Discipline.fetchObject(named: disciplineName, in: context) else {
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
        prerequisite: prerequisite
      )
      prerequisite?.dependentRituals.append(ritual)
      discipline.rituals.append(ritual)
      allRituals.append(ritual)
    }
    return allRituals
  }
  
  static func removeDuplicates(in context: NSManagedObjectContext) throws {
    let request: NSFetchRequest<Ritual> = Ritual.fetchRequest()
    let allRituals = try context.fetch(request)
    
    let groups = Dictionary(grouping: allRituals, by: \.refID)
    var toDelete: [Ritual] = []
    
    for (_, var rituals) in groups {
      if rituals.count == 1 { continue }
      
      guard let keptRitual = rituals.removeMax() else { continue }
      
      for removedRitual in rituals {
        guard let kindred = removedRitual.referencingKindred else { continue }
        keptRitual.addToReferencingKindred(kindred)
        
        toDelete.append(removedRitual)
      }
    }
    
    for ritual in toDelete {
      context.delete(ritual)
    }
  }
  
}
