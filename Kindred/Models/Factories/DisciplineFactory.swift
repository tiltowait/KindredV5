//
//  DisciplineFactory.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/20/21.
//

import Foundation
import CoreData
import SwiftCSV

/// Factory class for loading `Discipline`s from CSV.
class DisciplineFactory {
  
  private let context: NSManagedObjectContext // Used for Discipline and Power creation
  
  /// Creates a basic `DisciplineFactory`. To use, call `fetchAll()`.
  /// - Parameter context: The CoreData context for storing `Discipline`s.
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  /// Fetches all `Discipline` objects from CSV and associates them with their `Power`s.
  /// - Returns: An array of complete `Discipline` objects.
  func fetchAll() -> [Discipline] {
    let powers = fetchPowers()
    let disciplines = fetchDisciplines()
    
    // Associate powers with the correct discipline
    for discipline in disciplines {
      guard let powers = powers[discipline.name!] else { // TODO: Extension
        fatalError("No associated powers for \(discipline.name!)") // TODO: Extension
      }
      powers.forEach { discipline.addToPowers($0) }
    }
    
    return disciplines
  }
  
  /// Loads all the `Discipline` objects from CSV.
  /// - Returns: An array of `Discipline`s.
  private func fetchDisciplines() -> [Discipline] {
    var disciplines: [Discipline] = []
    
    do {
      guard let disciplineURL = Bundle.main.url(forResource: "Disciplines", withExtension: "csv") else {
        fatalError("Unable to locate Disciplines.csv.")
      }
      let csv = try CSV(url: disciplineURL)
      
      // Scheme: Discipline, Info
      try csv.enumerateAsDict { row in
        let discipline = Discipline(context: self.context)
        discipline.name = row["Discipline"]
        discipline.info = row["Info"]
        discipline.icon = row["Icon"]
        
        disciplines.append(discipline)
      }
    } catch {
      fatalError("Unable to load disciplines.\n\(error.localizedDescription)")
    }
    
    return disciplines
  }
  
  /// Loads all the `Power` objects from CSV.
  /// - Returns: A dictionary where the key is a discipline name, and corresponding values are `Power` arrays.
  private func fetchPowers() -> [String: [Power]] {
    var allPowers: [String: [Power]] = [:]
    
    do {
      guard let powerURL = Bundle.main.url(forResource: "Powers", withExtension: "csv") else {
        fatalError("Unable to locate Powers.csv.")
      }
      let csv = try CSV(url: powerURL)
      
      // Format for power CSV: [Power, Discipline, Level, Rouse, Pool, Info, Duration, Prerequisite, Source, Page]
      try csv.enumerateAsDict{ row in
        let power = Power(context: self.context)
        power.name = row["Power"]
        power.level = Int16(row["Level"]!)!
        power.rouse = Int16(row["Rouse"]!)!
        power.pool = row["Pool"] // Optional
        power.info = row["Info"]
        power.prerequisite = row["Prerequisite"] // Optional
        power.duration = row["Duration"]
        power.source = Int16(row["Source"]!)!
        power.page = Int16(row["Page"]!)!
        
        let discipline = row["Discipline"]!
        allPowers[discipline, default: []].append(power)
      }
    } catch {
      fatalError("Unable to load powers.\n\(error.localizedDescription)")
    }
    
    return allPowers
  }
  
}
