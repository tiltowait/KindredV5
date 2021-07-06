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
    }
  }
  
}
