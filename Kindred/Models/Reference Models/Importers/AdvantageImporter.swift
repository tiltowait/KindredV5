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
  
  static func importAll<T: InfoItem>(of type: T.Type) throws -> [T] {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let advantages = Table("advantages")
    
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let isBackground = Expression<Int>("background")
    let refID = Expression<Int>("refID")
    
    var allAdvantages: [T] = []
    
    for row in try db.prepare(advantages) {
      let refID = Int16(row[refID])
      let advantage = Advantage(
        id: refID,
        name: row[name],
        info: row[info],
        isBackground: row[isBackground] == 1
      )
      try Self.importOptions(for: advantage)
      allAdvantages.append(advantage as! T)
    }
    return allAdvantages
  }
  
  private static func importOptions(for advantage: Advantage) throws {
    let db = try Connection(Global.referenceDatabasePath, readonly: true)
    let advantageOptions = Table("advantage_options")
    
    let name = Expression<String>("name")
    let info = Expression<String>("info")
    let source = Expression<Int>("source")
    let page = Expression<Int>("page")
    let min = Expression<Int>("min")
    let max = Expression<Int>("max")
    let parent = Expression<String>("parent")
    let refID = Expression<Int>("refID")
    
    for row in try db.prepare(advantageOptions) where row[parent] == advantage.name {
      let refID = Int16(row[refID])
      let option = AdvantageOption(
        id: refID,
        name: row[name],
        info: row[info],
        page: Int16(row[page]),
        source: Int16(row[source]),
        maxRating: Int16(row[min]),
        minRating: Int16(row[max]),
        parentAdvantage: advantage
      )
      advantage.allOptions.append(option)
    }
  }
}
