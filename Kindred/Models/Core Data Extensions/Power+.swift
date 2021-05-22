//
//  Power+.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import Foundation

// MARK: - Non-Optional Accessors
extension Power {
  
  var powerName: String {
    self.name!
  }
  
  var powerInfo: String {
    self.info!
  }
  
  var powerDuration: String {
    self.duration!
  }
  
  var sourceBook: Global.Source {
    Global.Source(rawValue: self.source)!
  }
  
}

// MARK: - Comparable
extension Power: Comparable {
  
  public static func < (lhs: Power, rhs: Power) -> Bool {
    if lhs.level < rhs.level {
      return true
    } else if lhs.level == rhs.level {
      return lhs.powerName < rhs.powerName
    }
    return false
  }
  
}
