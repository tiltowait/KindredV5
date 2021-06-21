//
//  AdvantageOptionImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import CoreData
import SQLite

enum AdvantageOptionImporter: Importer {
  
  static func importAll(context: NSManagedObjectContext) throws {
    guard let dbPath = Global.dbPath else {
      throw ImportError.databaseNotFound
    }
    let db = try Connection(dbPath, readonly: true)
    let advantageOptions = Table("advantage_options")
    
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let source = Expression<Int>("source")
    let page = Expression<Int>("page")
    let min = Expression<Int>("min")
    let max = Expression<Int>("max")
    let parent = Expression<String>("parent")
    
    for row in try db.prepare(advantageOptions) {
      let option = AdvantageOption(context: context)
      option.name = row[name]
      option.info = row[info]
      option.source = Int16(row[source])
      option.page = Int16(row[page])
      option.minRating = Int16(row[min])
      option.maxRating = Int16(row[max])
      
      guard let parentAdvantage = Advantage.fetchObject(named: row[parent], in: context) else {
        throw ImportError.invalidReference("No Advantage named \(row[parent])")
      }
      option.parentAdvantage = parentAdvantage
    }
  }
  
}
