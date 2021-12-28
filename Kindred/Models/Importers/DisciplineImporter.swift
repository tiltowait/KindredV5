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
      discipline.version = Int16(row[version])
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
      power.zPrerequisites = row[prerequisite]
      power.source = Int16(row[source])
      power.page = Int16(row[page])
      power.version = Int16(row[version])
      
      // Get the disciplines
      let disciplineName = row[disciplineName]
      guard let discipline = Discipline.fetchObject(named: disciplineName, in: context) else {
        throw ImportError.invalidReference("\(disciplineName) is not a valid Discipline!")
      }
      power.discipline = discipline
      power.refID = refID
    }
  }
  
  static func removeDuplicates(in context: NSManagedObjectContext) throws {
    let request: NSFetchRequest<Discipline> = Discipline.fetchRequest()
    let allDisciplines = try context.fetch(request)
    
    let groups = Dictionary(grouping: allDisciplines, by: \.refID)
    var toDelete: [Discipline] = []
    
    for (_, var disciplines) in groups {
      if disciplines.count > 1 {
        guard let keptDiscipline = disciplines.removeMax() else { continue }
        
        for removedDiscipline in disciplines {
          // Powers
          for removingPower in removedDiscipline.allPowers {
            guard let keptPower = keptDiscipline.allPowers.first(where: { $0.refID == removingPower.refID }) else { continue }
            
            // Kindred
            if let kindred = removingPower.kindred, kindred.count > 0 {
              keptPower.addToKindred(kindred)
            }
            
            // Rituals
            if let rituals = removingPower.dependentRituals {
              keptPower.addToDependentRituals(rituals)
            }
          }
          
          // Rituals
          if let rituals = removedDiscipline.rituals {
            keptDiscipline.addToRituals(rituals)
          }
          
          toDelete.append(removedDiscipline)
        }
      }
    }
    
    for discipline in toDelete {
      context.delete(discipline)
    }
  }
  
}
