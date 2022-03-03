//
//  Power.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

class Power: ReferenceItem {
  let id: Int16
  let name: String
  let info: String
  let page: Int16
  let source: Int16
  
  let powerDuration: String
  let level: Int16
  let pool: String?
  let rouse: Int16
  let prerequisites: String?
  
  let dependentRituals: [Ritual]
  let discipline: Discipline
  
  var disciplineName: String { self.discipline.name }
  var amalgams: [String]? {
    prerequisites?.components(separatedBy: ", ").filter { $0.last!.isNumber }
  }
  
  init(id: Int16, name: String, info: String, page: Int16, source: Int16, powerDuration: Stringg, level: Int16, pool: String?, rouse: Int16, prerequisites: String?, dependentRituals: [Ritual], discipline: Discipline) {
    self.id = id
    self.name = name
    self.info = info
    self.page = page
    self.source = source
    self.powerDuration = powerDuration
    self.level = level
    self.pool = pool
    self.rouse = rouse
    self.prerequisites = prerequisites
    self.dependentRituals = dependentRituals
    self.discipline = discipline
  }
}

extension Power: Comparable {
  static func < (lhs: Power, rhs: Power) -> Bool {
    if lhs.level < rhs.level {
      return true
    } else if lhs.level == rhs.level {
      return lhs.name < rhs.name
    }
    return false
  }
}
