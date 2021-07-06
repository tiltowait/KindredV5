//
//  LoresheetImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/6/21.
//

import CoreData
import SQLite

enum LoresheetImporter: Importer {
  
  static func importAll(after currentVersion: Int, context: NSManagedObjectContext) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let version = Expression<Int>("version")
    let loresheets = Table("loresheets").filter(version > currentVersion)
    
    // Set up the columns
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let source = Expression<Int>("source")
    let page = Expression<Int>("page")
    let clan = Expression<String?>("clan")
    let refID = Expression<Int>("refID")
    
    for row in try db.prepare(loresheets) {
      let refID = Int16(row[refID])
      let loresheet = Loresheet.fetchItem(id: refID, in: context) ?? Loresheet(context: context)
      
      loresheet.name = row[name]
      loresheet.info = row[info]
      loresheet.source = Int16(row[source])
      loresheet.page = Int16(row[page])
      loresheet.refID = refID
      
      // Get the clan, if any
      if let clanName = row[clan] {
        guard let clan = Clan.fetchObject(named: clanName, in: context) else {
          throw ImportError.invalidReference("\(clanName) is not a valid clan!")
        }
        loresheet.requiredClan = clan
      }
    }
    
    try Self.importLoresheetItems(after: currentVersion, context: context)
  }
  
  private static func importLoresheetItems(after currentVersion: Int, context: NSManagedObjectContext) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let version = Expression<Int>("version")
    let loresheetItems = Table("loresheet_items").filter(version > currentVersion)

    // Set up the columns
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let level = Expression<Int>("level")
    let parent = Expression<String>("parent")
    let refID = Expression<Int>("refID")
    
    for row in try db.prepare(loresheetItems) {
      let refID = Int16(row[refID])
      let loresheetItem = LoresheetItem.fetchItem(id: refID, in: context) ?? LoresheetItem(context: context)
      
      loresheetItem.name = row[name]
      loresheetItem.info = row[info]
      loresheetItem.level = Int16(row[level])
      loresheetItem.refID = refID
      
      let parentName = row[parent]
      guard let parentLoresheet = Loresheet.fetchObject(named: parentName, in: context) else {
        throw ImportError.invalidReference("\(parentName) is not a valid loresheet!")
      }
      loresheetItem.parent = parentLoresheet
    }
  }
  
}
