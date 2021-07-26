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
  
  enum Prerequisite {
    case amalgam(String)
    case prerequisite(String)
    case none
  }
  
  /// The name of the power's containing `Discipline`.
  var disciplineName: String {
    self.discipline!.name
  }
  
  /// The power's duration.
  var powerDuration: String {
    self.duration!
  }
  
  var powerPrerequisite: Prerequisite {
    if let lastChar = prerequisite?.last {
      if lastChar.isNumber {
        return .amalgam(prerequisite!)
      }
      return .prerequisite(prerequisite!)
    }
    return .none
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
