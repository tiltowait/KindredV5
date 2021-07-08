//
//  AdvantageImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import CoreData
import SQLite

/// A data importer responsible for importing advantages and their associated options.
enum AdvantageImporter: Importer {
  
  static func importAll(after currentVersion: Int, context: NSManagedObjectContext) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let version = Expression<Int>("version")
    let advantages = Table("advantages").filter(version > currentVersion)
    
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let isBackground = Expression<Int>("background")
    let refID = Expression<Int>("refID")
    
    for row in try db.prepare(advantages) {
      let refID = Int16(row[refID])
      let advantage = Advantage.fetchItem(id: refID, in: context) ?? Advantage(context: context)
      
      advantage.name = row[name]
      advantage.info = row[info]
      advantage.isBackground = row[isBackground] == 1
      advantage.refID = refID
    }
    
    try Self.importOptions(after: currentVersion, context: context)
  }
  
  private static func importOptions(after currentVersion: Int, context: NSManagedObjectContext) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let version = Expression<Int>("version")
    let advantageOptions = Table("advantage_options").filter( version > currentVersion)
    
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let source = Expression<Int>("source")
    let page = Expression<Int>("page")
    let min = Expression<Int>("min")
    let max = Expression<Int>("max")
    let parent = Expression<String>("parent")
    let refID = Expression<Int>("refID")
    
    for row in try db.prepare(advantageOptions) {
      let refID = Int16(row[refID])
      let option = AdvantageOption.fetchItem(id: refID, in: context) ?? AdvantageOption(context: context)
      
      option.name = row[name]
      option.info = row[info]
      option.source = Int16(row[source])
      option.page = Int16(row[page])
      option.minRating = Int16(row[min])
      option.maxRating = Int16(row[max])
      
      guard let parentAdvantage = Advantage.fetchObject(named: row[parent], in: context) else {
        throw ImportError.invalidReference("No Advantage named \(row[parent])")
      }
      option.parent = parentAdvantage
      option.refID = refID
    }
  }
  
}
