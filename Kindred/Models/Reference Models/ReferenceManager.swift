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
  // This hack is ugly as sin, but the problem is that certain importers need to reference
  // previously imported data. The solution would be to combine some of the importers into
  // one, which may eventually be done in the future.
  
  private(set) lazy var advantages: [Advantage] = {
    do {
      return try AdvantageImporter.importAll(of: Advantage.self).sorted()
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  private(set) lazy var advantageOptions: [AdvantageOption] = {
    self.advantages.flatMap { $0.allOptions }.sorted()
  }()
  private(set) lazy var clans: [Clan] = {
    do {
      return try ClanImporter.importAll(of: Clan.self).sorted()
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  private(set) lazy var disciplines: [Discipline] = {
    do {
      return try DisciplineImporter.importAll(of: Discipline.self).sorted()
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  private(set) lazy var loresheets: [Loresheet] = {
    do {
      return try LoresheetImporter.importAll(of: Loresheet.self).sorted()
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
      return try RitualImporter.importAll(of: Ritual.self).sorted()
    } catch {
      fatalError(error.localizedDescription)
    }
  }()
  
  //MARK: - Named Fetchers
  // Named fetchers are failable, because the user may have an unknown item in their
  // character PDF, or the SQLite database may have an error. Those cases need to be
  // treated separately.
  
  /// Fetch an advantage.
  /// - Parameter name: The advantage's name
  /// - Returns: The found advantage, or a generic one.
  func advantage(named name: String) -> Advantage? {
    advantages.first { $0.name == name }
  }
  
  /// Fetch an advantage option by name.
  /// - Parameter name: The option's name
  /// - Returns: The found option, or a generic one.
  func advantageOption(named name: String) -> AdvantageOption? {
    advantageOptions.first { $0.name == name }
  }
  
  /// Fetch a clan by name.
  /// - Parameter name: The clan's name
  /// - Returns: The clan, if found.
  func clan(named name: String) -> Clan? {
    clans.first { $0.name == name }
  }
  
  /// Fetch a discipline by name.
  /// - Parameter name: The discipline's name
  /// - Returns: The found discipline, or a generic one.
  func discipline(named name: String) -> Discipline? {
    return disciplines.first { $0.name == name }
  }
  
  /// Fetch a loresheet by name.
  /// - Parameter name: The loresheet's name
  /// - Returns: The found loresheet, or a generic one
  func loresheet(named name: String) -> Loresheet? {
    loresheets.first { $0.name == name }
  }
  
  /// Fetch a loresheet entry by name.
  /// - Parameter name: The entry's name
  /// - Returns: The found entry, or a generic one.
  func loresheetEntry(named name: String) -> LoresheetEntry? {
    loresheetEntries.first { $0.name == name }
  }
  
  /// Fetch a power by name.
  /// - Parameter name: The power's name
  /// - Returns: The found power, or a generic one.
  func power(named name: String) -> Power? {
    powers.first { $0.name == name }
  }
  
  /// Fetch a ritual by name.
  /// - Parameter name: The ritual's name
  /// - Returns: The found ritual, or a generic one.
  func ritual(named name: String) -> Ritual {
    rituals.first { $0.name == name } ?? Ritual.unknown
  }
  
  //MARK: - ID Fetchers
  // ID fetchers are used by Core Data. Because of this, if the user hasn't updated their
  // app, they can potentially fail. Instead of crashing or displaying nothing, we will
  // show users generic items that prompt them to update the app.
  
  /// Fetch an advantage option by ID.
  /// - Parameter id: The option's ID
  /// - Returns: The found option, or a generic one.
  func advantageOption(id: Int16) -> AdvantageOption {
    self.advantageOptions.first { $0.id == id } ?? AdvantageOption.unknown
  }
  
  /// Fetch a clan by ID.
  /// - Parameter id: The clan's ID
  /// - Returns: The found clan, or a generic one.
  func clan(id: Int16) -> Clan {
    self.clans.first { $0.id == id } ?? Clan.unknown
  }
  
  /// Fetch a loresheet entry by ID.
  /// - Parameter id: The entry's ID
  /// - Returns: The found entry, or a generic one.
  func loresheetEntry(id: Int16) -> LoresheetEntry {
    self.loresheetEntries.first { $0.id == id } ?? LoresheetEntry.unknown
  }
  
  /// Fetch a power by ID.
  /// - Parameter id: The power's ID
  /// - Returns: The found power, or a generic one.
  func power(id: Int16) -> Power {
    self.powers.first { $0.id == id } ?? Power.unknown
  }
  
  /// Fetch a ritual by ID.
  /// - Parameter id: The ritual's ID
  /// - Returns: The found ritual, or a generic one.
  func ritual(id: Int16) -> Ritual {
    self.rituals.first { $0.id == id } ?? Ritual.unknown
  }
  
  private init() { }
}
