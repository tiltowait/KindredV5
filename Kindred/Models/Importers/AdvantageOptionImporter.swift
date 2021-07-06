//
//  AdvantageOptionImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import CoreData
import SQLite

enum AdvantageOptionImporter: Importer {
  
  static func importAll(after currentVersion: Int, context: NSManagedObjectContext) throws {
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
