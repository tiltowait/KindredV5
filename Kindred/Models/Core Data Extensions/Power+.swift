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
    self.discipline!.disciplineName
  }
  
  /// The power's name.
  var powerName: String {
    self.name!
  }
  
  /// The power's description.
  var powerInfo: String {
    self.info!
  }
  
  /// The power's duration.
  var powerDuration: String {
    self.duration!
  }
  
  /// The book the power is found in.
  var sourceBook: Global.Source {
    Global.Source(rawValue: self.source)!
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
    if lhs.disciplineName < rhs.disciplineName {
      return false
    } else if lhs.level < rhs.level {
      return true
    } else if lhs.level == rhs.level {
      return lhs.powerName < rhs.powerName
    }
    return false
  }
  
}
