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
  
  let entries: [LoresheetEntry]
  let requiredClans: [Clan]
  
  var clanRestrictions: [Clan]? {
    if let restrictions = self.requiredClans?.allObjects as? [Clan] {
      return restrictions.isEmpty ? nil : restrictions.sorted { $0.name < $1.name }
    }
    return nil
  }
  
  init(id: Int16, name: String, info: String, page: Int16, source: Int16, entries: [LoresheetEntry], requiredClans: [Clan]) {
    self.id = id
    self.name = name
    self.info = info
    self.page = page
    self.source = source
    self.entries = entries
    self.requiredClans = requiredClans
  }
}

extension Loresheet: Comparable {
  static func <(lhs: Loresheet, rhs: Loresheet) -> Bool {
    lhs.name < rhs.name
  }
}
