//
//  Discipline.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

class Discipline: InfoItem {
  let id: Int16
  let name: String
  let info: String
  let icon: String
  let resonance: String
  
  let allPowers: [Power]
  let rituals: [Ritual]
  
  var allowsRituals: Bool { rituals?.count == 0 }
  
  init(id: Int16, name: String, info: String, icon: String, resonance: String, allPowers: [Power], rituals: [Ritual]) {
    self.id = id
    self.name = name
    self.info = info
    self.icon = icon
    self.resonance = resonance
    self.allPowers = allPowers
    self.rituals = rituals
  }
  
  func powers(fromSource source: Global.Source) -> [Power] {
    allPowers.filter { $0.source == source.rawValue }
  }
}

extension Discipline: Comparable {
  static func <(lhs: Discipline, rhs: Discipline) -> Bool {
    lhs.name < rhs.name
  }
}
