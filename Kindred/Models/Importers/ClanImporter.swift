//
//  ClanImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import CoreData
import SQLite

enum ClanImporter: Importer {
  
  static func importAll(after currentVersion: Int, context: NSManagedObjectContext) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let version = Expression<Int>("version")
    let clans = Table("clans").filter(version > currentVersion)
    
    let name = Expression<String>("name")
    let nicknames = Expression<String>("nicknames")
    let info = Expression<String>("info")
    let source = Expression<Int>("source")
    let page = Expression<Int>("page")
    let bane = Expression<String?>("bane")
    let compulsion = Expression<String?>("compulsion")
    let compulsionDetails = Expression<String?>("compulsion_details")
    let disciplines = Expression<String?>("disciplines")
    let template = Expression<Int>("template")
    let icon = Expression<String>("icon")
    let header = Expression<String>("header")
    let refID = Expression<Int>("refID")
    
    for row in try db.prepare(clans) {
      let refID = Int16(row[refID])
      let clan = Clan.fetchItem(id: refID, in: context) ?? Clan(context: context)
      
      clan.name = row[name]
      clan.zNicknames = row[nicknames]
      clan.info = row[info]
      clan.source = Int16(row[source])
      clan.page = Int16(row[page])
      clan.bane = row[bane]
      clan.compulsion = row[compulsion]
      clan.compulsionDetails = row[compulsionDetails]
      
      // Add the in-clan disciplines, but only if the clan is new
      //
      // This approach has an important limitation regarding clans: namely, it isn't currently possible
      // to update the disciplines associated with a clan. As in-clan disciplines have historically
      // been stable, this is not likely to be a problem in the future; however, should it become one
      // somewhere down the line, it will be easy enough to fix.
      
      if clan.refID == -1 {
        if let disciplines = row[disciplines] {
          let inClanDisciplines = disciplines.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
          for name in inClanDisciplines {
            guard let discipline = Discipline.fetchObject(named: name, in: context) else {
              throw ImportError.invalidReference("\(name) is not a known Discipline!")
            }
            clan.addToDisciplines(discipline)
          }
        }
      }
      
      clan.rawTemplate = Int16(row[template])
      clan.icon = row[icon]
      clan.header = row[header]
      
      clan.refID = refID
      clan.version = Int16(row[version])
    }
  }
  
  static func removeDuplicates(in context: NSManagedObjectContext) throws {
    let request: NSFetchRequest<Clan> = Clan.fetchRequest()
    let allClans = try context.fetch(request)
    
    let groups = Dictionary(grouping: allClans, by: \.refID)
    var toDelete: [Clan] = []
    
    for (_, var clans) in groups {
      guard clans.count > 1 else { continue }
      
      guard let keptClan = clans.removeMax() else { continue }
      
      for removedClan in clans {
        if let loresheets = removedClan.referencingLoresheets {
          keptClan.addToReferencingLoresheets(loresheets)
        }
        
        if let kindred = removedClan.kindred {
          keptClan.addToKindred(kindred)
        }
        
        if let disciplines = removedClan.disciplines {
          keptClan.addToDisciplines(disciplines)
        }
        
        toDelete.append(removedClan)
      }
    }
    
    for clan in toDelete {
      context.delete(clan)
    }
  }
  
}
