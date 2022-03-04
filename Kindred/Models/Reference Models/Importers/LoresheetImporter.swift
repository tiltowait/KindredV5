//
//  LoresheetImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/6/21.
//

import CoreData
import SQLite

enum LoresheetImporter: Importer {
  
  static func importAll<T: InfoItem>(of type: T.Type) throws -> [T] {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let loresheets = Table("loresheets")
    
    // Set up the columns
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let source = Expression<Int>("source")
    let page = Expression<Int>("page")
    let clan = Expression<String?>("clan")
    let refID = Expression<Int>("refID")
    
    var allLoresheets: [T] = []
    
    for row in try db.prepare(loresheets) {
      let refID = Int16(row[refID])
      let loresheet = Loresheet(
        id: refID,
        name: row[name],
        info: row[info],
        page: Int16(row[page]),
        source: Int16(row[source])
      )
      
      // Loresheets can have multiple clan entries
      if let clanNames = row[clan]?.components(separatedBy: ", ") {
        for clanName in clanNames {
          guard let clan = ReferenceManager.shared.clan(named: clanName) else {
            throw ImportError.invalidReference("\(clanName) is not a valid clan!")
          }
          loresheet.requiredClans.append(clan)
        }
      }
      try Self.importLoresheetEntries(for: loresheet)
      loresheet.entries.sort()
      allLoresheets.append(loresheet as! T)
    }
    return allLoresheets
  }
  
  private static func importLoresheetEntries(for loresheet: Loresheet) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let loresheetItems = Table("loresheet_entries")

    // Set up the columns
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let level = Expression<Int>("level")
    let parent = Expression<String>("parent")
    let refID = Expression<Int>("refID")
    
    for row in try db.prepare(loresheetItems) where row[parent] == loresheet.name {
      let refID = Int16(row[refID])
      let loresheetMerit = LoresheetEntry(
        id: refID,
        name: row[name],
        info: row[info],
        level: Int16(row[level]),
        parent: loresheet
      )
      loresheet.entries.append(loresheetMerit)
    }
  }
}
