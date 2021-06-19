//
//  ClanImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import CoreData
import SQLite

enum ClanImporter: Importer {
  
  static func importAll(context: NSManagedObjectContext) throws {
    guard let dbPath = Bundle.main.path(forResource: "reference.sqlite", ofType: nil) else {
      throw ImportError.databaseNotFound
    }
    let db = try Connection(dbPath, readonly: true)
    let clans = Table("clans")
    
    let name = Expression<String>("name")
    let nicknames = Expression<String>("nicknames")
    let info = Expression<String>("info")
    let source = Expression<Int>("source")
    let page = Expression<Int>("page")
    let bane = Expression<String>("bane")
    let compulsion = Expression<String>("compulsion")
    let compulsionDetails = Expression<String>("compulsion_details")
    let disciplines = Expression<String>("disciplines")
    let icon = Expression<String>("icon")
    let header = Expression<String>("header")
    
    for row in try db.prepare(clans) {
      let clan = Clan(context: context)
      clan.name = row[name]
      clan.zNicknames = row[nicknames]
      clan.info = row[info]
      clan.source = Int16(row[source])
      clan.page = Int16(row[page])
      clan.bane = row[bane]
      clan.compulsion = row[compulsion]
      clan.compulsionDetails = row[compulsionDetails]
      
      // Add the in-clan disciplines
      let inClanDisciplines = row[disciplines].components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      for name in inClanDisciplines {
        guard let discipline = Discipline.fetchObject(named: name, in: context) else {
          throw ImportError.invalidReference("\(name) is not a known Discipline!")
        }
        clan.addToDisciplines(discipline)
      }
      
      clan.icon = row[icon]
      clan.header = row[header]
    }
  }
  
}
