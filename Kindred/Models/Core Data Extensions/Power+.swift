//
//  Power+.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import Foundation
import CoreData

// MARK: - Non-Optional Accessors
extension Power {
  
  /// The name of the power's containing `Discipline`.
  var disciplineName: String {
    self.discipline!.name
  }
  
  /// The power's duration.
  var powerDuration: String {
    self.duration!
  }
  
  /// Individual power(s) the character must possess to know this power.
  var prerequisitePowers: [String]? {
    self.zPrerequisites?.components(separatedBy: ", ").filter { !$0.last!.isNumber }
  }
  
  /// Discipline ratings a character must attain to know this power.
  var amalgams: [String]? {
    self.zPrerequisites?.components(separatedBy: ", ").filter { $0.last!.isNumber }
  }
  
}

// MARK: - Additional Functions and Computed Properties
extension Power {
  
  /// An `NSFetchRequest` that returns all `Power`s in the store.
  static var allPowersFetchRequest: NSFetchRequest<Power> {
    let request: NSFetchRequest<Power> = Power.fetchRequest()
    return request
  }
  
}

// MARK: - Comparable
extension Power: Comparable {
  
  public static func < (lhs: Power, rhs: Power) -> Bool {
    if lhs.level < rhs.level {
      return true
    } else if lhs.level == rhs.level {
      return lhs.name < rhs.name
    }
    return false
  }
  
}
