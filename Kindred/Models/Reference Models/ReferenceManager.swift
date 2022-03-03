//
//  ReferenceManager.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

class ReferenceManager {
  static let shared = ReferenceManager()
  
  // MARK: - Reference Material
  
  private(set) lazy var advantages: [Advantage] = {
    do {
      return try AdvantageImporter.importAll(of: Advantage.self)
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  private(set) lazy var advantageOptions: [AdvantageOption] = {
    self.advantages.flatMap { $0.allOptions }.sorted()
  }()
  private(set) lazy var clans: [Clan] = {
    do {
      return try ClanImporter.importAll(of: Clan.self)
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  private(set) lazy var disciplines: [Discipline] = {
    do {
      return try DisciplineImporter.importAll(of: Discipline.self)
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  private(set) lazy var loresheets: [Loresheet] = {
    do {
      return try LoresheetImporter.importAll(of: Loresheet.self)
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  private(set) lazy var loresheetEntries: [LoresheetEntry] = {
    self.loresheets.flatMap { $0.entries }.sorted()
  }()
  private(set) lazy var powers: [Power] = {
    self.disciplines.flatMap { $0.allPowers }.sorted()
  }()
  private(set) lazy var rituals: [Ritual] = {
    do {
      return try RitualImporter.importAll(of: Ritual.self)
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  
  //MARK: - Named Fetchers
  
  func advantage(named name: String) -> Advantage? {
    advantages.first { $0.name == name }
  }
  
  func advantageOption(named name: String) -> AdvantageOption? {
    advantageOptions.first { $0.name == name }
  }
  
  func clan(named name: String) -> Clan? {
    clans.first { $0.name == name }
  }
  
  func discipline(named name: String) -> Discipline? {
    return disciplines.first { $0.name == name }
  }
  
  func loresheet(named name: String) -> Loresheet? {
    loresheets.first { $0.name == name }
  }
  
  func loresheetEntry(named name: String) -> LoresheetEntry? {
    loresheetEntries.first { $0.name == name }
  }
  
  func power(named name: String) -> Power? {
    powers.first { $0.name == name }
  }
  
  func ritual(named name: String) -> Ritual? {
    rituals.first { $0.name == name }
  }
  
  //MARK: - ID Fetchers
  
  func advantageOption(id: Int16) -> AdvantageOption? {
    self.advantageOptions.first { $0.id == id }
  }
  
  func clan(id: Int16) -> Clan? {
    self.clans.first { $0.id == id }
  }
  
  func power(id: Int16) -> Power? {
    self.powers.first { $0.id == id }
  }
  
  func ritual(id: Int16) -> Ritual? {
    self.rituals.first { $0.id == id }
  }
  
  func loresheetEntry(id: Int16) -> LoresheetEntry? {
    self.loresheetEntries.first { $0.id == id }
  }
  
  private init() { }
}
