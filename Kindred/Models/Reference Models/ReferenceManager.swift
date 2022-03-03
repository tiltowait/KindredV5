//
//  ReferenceManager.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

class ReferenceManager {
  static let shared = ReferenceManager()
  
  let advantages: [Advantage]
  let clans: [Clan]
  let disciplines: [Discipline]
  let loresheets: [Loresheet]
  let powers: [Power]
  let rituals: [Ritual]
  
  func advantage(named name: String) -> Advantage? {
    advantages.first { $0.name == name }
  }
  
  func clan(named name: String) -> Clan? {
    clans.first { $0.name == name }
  }
  
  func discipline(named name: String) -> Discipline? {
    disciplines.first { $0.name == name }
  }
  
  func loresheet(named name: String) -> Loresheet? {
    loresheets.first { $0.name == name }
  }
  
  func power(named name: String) -> Power? {
    powers.first { $0.name == name }
  }
  
  private init() {
    self.disciplines = DisciplineImporter.importAll(of: Discipline.self)
    self.powers = self.disciplines.reduce([Power]()) { $0.allPowers }.sorted()
    self.clans = ClanImporter.importAll(of: Clan.self)
    self.rituals = RitualImporter.importAll(of: Ritual.self)
    self.advantages = AdvantageImporter.importAll(of: Advantage.self)
    self.loresheets = LoresheetImporter.importAll(of: Loresheet.self)
  }
}
