//
//  AdvantageContainer+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import Foundation

extension AdvantageContainer {
  
  var option: AdvantageOption {
    ReferenceManager.shared.advantageOption(id: self.refID)
  }
  
  var advantage: Advantage {
    option.parentAdvantage
  }
  
  var isBackground: Bool {
    option.parentAdvantage.isBackground
  }
  
  var isFlaw: Bool {
    option.isFlaw
  }
  
  var isMerit: Bool {
    !isBackground && !isFlaw
  }
  
  /// The full name of the contained AdvantageOption, in the format "Advantage, option".
  var fullName:String {
    option.fullName
  }
  
}

extension AdvantageContainer: Comparable {
  public static func < (lhs: AdvantageContainer, rhs: AdvantageContainer) -> Bool {
    // Sorting rules:
    // 0. Special rule: Haven is always first.
    // 1. Alphabetical by parent advantage name
    // 2. Ascending by current rating
    // 3. Alphabetical by option name
    
    // 0.
    if lhs.option.name == "Haven" {
      return true
    } else if rhs.option.name == "Haven" {
      return false
    }
    
    // 1.
    if lhs.advantage.name < rhs.advantage.name {
      return true
    }
    if lhs.advantage == rhs.advantage {
      // 2.
      if lhs.currentRating < rhs.currentRating {
        return true
      }
      
      // 3.
      if lhs.currentRating == rhs.currentRating {
        return lhs.option.name < rhs.option.name
      }
    }
    return false
  }
}
