//
//  DisciplineFactory.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/20/21.
//

import Foundation
import CoreData
import SwiftCSV

/// Factory namespace for loading `Discipline`s from CSV.
enum DisciplineFactory {
  
  /// Loads all `Discipline` objects from CSV and associates them with their `Power`s. This function does *no* checking for
  /// existing data and will add duplicates if they already exist!
  /// - Parameter context: The `NSManagedObjectContext` for the `Disciplines` and `Powers`.
  static func loadAll(context: NSManagedObjectContext) {
    let powers = loadPowers(context: context)
    let disciplines = loadDisciplines(context: context)
    
    // Associate powers with the correct discipline
    for discipline in disciplines {
      guard let powers = powers[discipline.name] else { // TODO: Extension
        fatalError("No associated powers for \(discipline.name)") // TODO: Extension
      }
      powers.forEach { discipline.addToPowers($0) }
    }
  }
  
  /// Loads all the `Discipline` objects from CSV.
  /// - Parameter context: The `NSManagedObjectContext` for the `Discipline`s.
  /// - Returns: An array of `Discipline`s.
  static private func loadDisciplines(context: NSManagedObjectContext) -> [Discipline] {
    var disciplines: [Discipline] = []
    
    do {
      guard let disciplineURL = Bundle.main.url(forResource: "Disciplines", withExtension: "csv") else {
        fatalError("Unable to locate Disciplines.csv.")
      }
      let csv = try CSV(url: disciplineURL)
      
      // Scheme: Discipline, Info
      try csv.enumerateAsDict { row in
        let discipline = Discipline(context: context)
        discipline.name = row["Discipline"]!
        discipline.info = row["Info"]!
        discipline.icon = row["Icon"]
        discipline.resonance = row["Resonance"]
        
        disciplines.append(discipline)
      }
    } catch {
      fatalError("Unable to load disciplines.\n\(error.localizedDescription)")
    }
    
    return disciplines
  }
  
  /// Loads all the `Power` objects from CSV.
  /// - Parameter context: The `NSManagedObjectContext` for the `Powers`.
  /// - Returns: A dictionary where the key is a discipline name, and corresponding values are `Power` arrays.
  static private func loadPowers(context: NSManagedObjectContext) -> [String: [Power]] {
    var allPowers: [String: [Power]] = [:]
    
    do {
      guard let powerURL = Bundle.main.url(forResource: "Powers", withExtension: "csv") else {
        fatalError("Unable to locate Powers.csv.")
      }
      let csv = try CSV(url: powerURL)
      
      // Format for power CSV: [Power, Discipline, Level, Rouse, Pool, Info, Duration, Prerequisite, Source, Page]
      try csv.enumerateAsDict{ row in
        let power = Power(context: context)
        power.name = row["Power"]!
        power.level = Int16(row["Level"]!)!
        power.rouse = Int16(row["Rouse"]!)!
        power.pool = row["Pool"]!.isEmpty ? nil : row["Pool"] // Optional
        power.info = row["Info"]!
        power.prerequisite = row["Prerequisite"]!.isEmpty ? nil : row["Prerequisite"] // Optional
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
