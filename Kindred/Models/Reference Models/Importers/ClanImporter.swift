//
//  ClanImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import CoreData
import SQLite

enum ClanImporter: Importer {
  
  static func importAll<T: InfoItem>(of type: T.Type) throws -> [T] {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let clans = Table("clans")
    
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
    
    var allClans: [T] = []
    
    for row in try db.prepare(clans) {
      let refID = Int16(row[refID])
      let clan = Clan(
        id: refID,
        name: row[name],
        info: row[info],
        page: Int16(row[page]),
        source: Int16(row[source]),
        bane: row[bane],
        compulsion: row[compulsion],
        compulsionDetails: row[compulsionDetails],
        rawTemplate: Int16(row[template]),
        header: row[header],
        icon: row[icon],
        nicknames: row[nicknames]
      )
      
      if let disciplines = row[disciplines] {
        let inClanDisciplines = disciplines.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        for name in inClanDisciplines {
          guard let discipline = ReferenceManager.shared.discipline(named: name) else {
            throw ImportError.invalidReference("\(name) is not a known Discipline!")
          }
          clan.inClanDisciplines.append(discipline)
        }
      }
      clan.inClanDisciplines.sort()
      allClans.append(clan as! T)
    }
    return allClans
  }
}
