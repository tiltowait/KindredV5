//
//  File.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

final class LoresheetEntry: InfoItem {
  let id: Int16
  let name: String
  let info: String
  let level: Int16
  
  let parent: Loresheet
  
  var fullName: String { "\(parent.name), \(name)"}
  
  init(id: Int16, name: String, info: String, level: Int16, parent: Loresheet) {
    self.id = id
    self.name = name
    self.info = info
    self.level = level
    self.parent = parent
  }
  
}

extension LoresheetEntry: Comparable {
  static func <(lhs: LoresheetEntry, rhs: LoresheetEntry) -> Bool {
    if lhs.level < rhs.level {
      return true
    }
    if lhs.level > rhs.level {
      return false
    }
    return lhs.name < rhs.name
  }
}

extension LoresheetEntry {
  static let unknown = LoresheetEntry(id: -1, name: "Unknown", info: "Update your app to the latest version.", level: 1, parent: Loresheet.unknown)
}
