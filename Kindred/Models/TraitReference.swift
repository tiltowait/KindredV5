//
//  TraitReference.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/20/21.
//

import Foundation
import SwiftCSV

/// Reference class for core attributes and skills. Provides both a list of traits as well as simplified descriptions of each trait's purpose.
class TraitReference {
  
  /// Contains the names and description of every core attribute and skill a character can have.
  private var allTraits: [String: String] = [:]
  
  private(set) var physicalAttributes: [String] = []
  private(set) var socialAttributes: [String] = []
  private(set) var mentalAttributes: [String] = []
  
  private(set) var physicalSkills: [String] = []
  private(set) var socialSkills: [String] = []
  private(set) var mentalSkills: [String] = []
  
  init() {
    do {
      // First, load the attributes
      guard let attributeURL = Bundle.main.url(forResource: "Attributes", withExtension: "csv") else {
        fatalError("Unable to locate Attributes.csv.")
      }
      var csv = try CSV(url: attributeURL)
      
      try csv.enumerateAsDict { row in
        // Attributes use the following keys: [Attribute, Category, Description]
        let attribute = row["Attribute"]!
        let category = row["Category"]!
        let description = row["Description"]!
        
        self.allTraits[attribute] = description
        
        switch category {
        case "Physical":
          self.physicalAttributes.append(attribute)
        case "Social":
          self.socialAttributes.append(attribute)
        case "Mental":
          self.mentalAttributes.append(attribute)
        default:
          fatalError("Unknown data in Attributes.csv")
        }
      }
      
      // Next, load the skills
      guard let skillURL = Bundle.main.url(forResource: "Skills", withExtension: "csv") else {
        fatalError("Unable to locate Skills.csv")
      }
      csv = try CSV(url: skillURL)
      
      try csv.enumerateAsDict { row in
        // Skills follow a similar scheme: [Skill, Category, Description]
        let skill = row["Skill"]!
        let category = row["Category"]!
        let description = row["Description"]!
        
        print(skill)
        self.allTraits[skill] = description
        
        switch category {
        case "Physical":
          self.physicalSkills.append(skill)
        case "Social":
          self.socialSkills.append(skill)
        case "Mental":
          self.mentalSkills.append(skill)
        default:
          fatalError("Unknown data field in Skills.csv.")
        }
      }
    } catch {
      fatalError("Unable to load core traits.\n\(error.localizedDescription)")
    }
  }
  
  // MARK: - Access Methods
  
  /// Provides the associated description for a given trait.
  /// - Parameter trait: The trait for which a description is desired.
  /// - Returns: The requested description, or nil.
  func description(forTrait trait: String) -> String? {
    allTraits[trait]
  }
  
}
