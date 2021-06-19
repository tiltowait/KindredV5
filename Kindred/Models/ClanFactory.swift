//
//  ClanFactory.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import Foundation
import CoreData
import SwiftCSV

enum ClanFactory {
  
  /// Loads all clans and stores them in the given context.
  ///
  /// This function does not save the data.
  /// - Parameters:
  ///   - context: The context in which to store the clans.
  ///   - disciplines: A list of disciplines. If a clan has a discipline not in the list, the app will crash.
  static func loadAll(context: NSManagedObjectContext, disciplines: [Discipline]) {
    guard let url = Bundle.main.url(forResource: "Clans", withExtension: "csv") else {
      fatalError("Unable to locate Clans.csv.")
    }
    
    do {
      let csv = try CSV(url: url)
      
      try csv.enumerateAsDict { row in
        let clan = Clan(context: context)
        
        // Clans have no optional values
        clan.name = row["Name"]!
        clan.info = row["Info"]!
        clan.source = Int16(row["Source"]!)!
        clan.page = Int16(row["Page"]!)!
        clan.bane = row["Bane"]!
        clan.compulsion = row["Compulsion"]!
        clan.compulsionDetails = row["Compulsion Details"]!
        
        // Disciplines are in a comma-separated list
        let disciplineNames = row["Disciplines"]!.components(separatedBy: ",")
        for discipline in disciplineNames {
          let name = discipline.trimmingCharacters(in: .whitespacesAndNewlines)
          let discipline = disciplines.first { $0.name == name }!
          
          clan.addToDisciplines(discipline)
        }
        
        // Icon and header
        clan.icon = row["Icon"]!
        clan.header = row["Header"]!
      }
    } catch {
      fatalError("Unable to load clans.\n\(error.localizedDescription)")
    }
  }
  
}
