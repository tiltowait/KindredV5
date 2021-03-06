//
//  Power.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

final class Power: ReferenceItem {
  let id: Int16
  let name: String
  let info: String
  let page: Int16
  let source: Int16
  
  let powerDuration: String
  let level: Int16
  let pool: String?
  let rouse: Int16
  
  let discipline: Discipline
  var dependentRituals: [Ritual] = []
  
  let amalgams: [String]?
  let prerequisitePowers: [String]?
  
  var disciplineName: String { self.discipline.name }
  
  init(id: Int16, name: String, info: String, page: Int16, source: Int16, powerDuration: String, level: Int16, pool: String?, rouse: Int16, prerequisites: String?, discipline: Discipline) {
    self.id = id
    self.name = name
    self.info = info
    self.page = page
    self.source = source
    self.powerDuration = powerDuration
    self.level = level
    self.pool = pool
    self.rouse = rouse
    self.discipline = discipline
    
    let prerequisites = prerequisites?.components(separatedBy: ", ")
    let prerequisitePowers = prerequisites?.filter { !$0.last!.isNumber }
    self.prerequisitePowers = (prerequisitePowers?.isEmpty ?? true) ? nil : prerequisitePowers
    
    let amalgams = prerequisites?.filter { $0.last!.isNumber }
    self.amalgams = (amalgams?.isEmpty ?? true) ? nil: amalgams
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

extension Power: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}

extension Power {
  static let unknown = Power(id: -1, name: "Unknown", info: "Update your app to the latest version.", page: 0, source: 0, powerDuration: "Unknown", level: 1, pool: nil, rouse: 0, prerequisites: nil, discipline: Discipline.unknown)
}
