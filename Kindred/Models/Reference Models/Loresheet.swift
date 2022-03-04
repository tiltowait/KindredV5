//
//  Loresheet.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

class Loresheet: ReferenceItem {
  let id: Int16
  let name: String
  let info: String
  let page: Int16
  let source: Int16
  
  var entries: [LoresheetEntry] = []
  var requiredClans: [Clan] = []
  
  var clanRestrictions: [Clan]? {
    return requiredClans.isEmpty ? nil : requiredClans.sorted { $0.name < $1.name }
  }
  
  init(id: Int16, name: String, info: String, page: Int16, source: Int16) {
    self.id = id
    self.name = name
    self.info = info
    self.page = page
    self.source = source
  }
}

extension Loresheet: Comparable {
  static func <(lhs: Loresheet, rhs: Loresheet) -> Bool {
    lhs.name < rhs.name
  }
}

extension Loresheet: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}

extension Loresheet {
  static let unknown: Loresheet = {
    let unknown = Loresheet(id: -1, name: "Unknown", info: "Update your app to the latest version.", page: 0, source: 0)
    unknown.entries.append(LoresheetEntry.unknown)
    return unknown
  }()
}
