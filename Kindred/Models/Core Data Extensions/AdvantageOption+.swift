//
//  AdvantageOption+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import CoreData

extension AdvantageOption {
  
  static var sortedFetchRequest: NSFetchRequest<AdvantageOption> {
    let request: NSFetchRequest<AdvantageOption> = AdvantageOption.fetchRequest()
    request.sortDescriptors = [
      NSSortDescriptor(keyPath: \AdvantageOption.minRating, ascending: true),
      NSSortDescriptor(keyPath: \AdvantageOption.maxRating, ascending: true),
      NSSortDescriptor(keyPath: \AdvantageOption.zName, ascending: true)
    ]
    return request
  }
  
  var isFlaw: Bool {
    minRating < 0 && maxRating < 0
  }
  
  var parentAdvantage: Advantage {
    self.parent!
  }
  
  /// The full name of the option, plus its parent advantage, in the format "Advantage, option".
  var fullName: String {
    "\(parentAdvantage.name), \(name)"
  }
  
}

extension AdvantageOption: Comparable {
  
  public static func < (lhs: AdvantageOption, rhs: AdvantageOption) -> Bool {
    if lhs.minRating < rhs.minRating {
      return true
    } else if lhs.minRating == rhs.minRating {
      if lhs.maxRating < rhs.maxRating {
        return true
      } else if lhs.maxRating == rhs.maxRating {
        return lhs.name < rhs.name
      } else {
        return false
      }
    } else {
      return false
    }
  }
  
  
}
