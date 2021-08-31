//
//  Ritual+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/27/21.
//

import Foundation

extension Ritual {
  
  var process: String {
    get { zProcess ?? "" }
    set { zProcess = newValue }
  }
  
  var system: String {
    get { zSystem ?? "" }
    set { zSystem = newValue }
  }
  
}

// MARK: - Ritual Types

extension Ritual {
  
  enum Flavor: String {
    case ritual = "Ritual"
    case ceremony = "Ceremony"
    case formula = "Formula"
    
    var disciplineName: String {
      switch self {
      case .ritual: return "Blood Sorcery"
      case .ceremony: return "Oblivion"
      case .formula: return "Thin-Blood Alchemy"
      }
    }
  }
  
  /// What to call the ritual: "ritual" or "ceremony".
  var flavor: Flavor {
    self.discipline?.name == "Blood Sorcery" ? .ritual : .ceremony
  }
  
}

// MARK: - Comparable

extension Ritual: Comparable {
  
  public static func < (lhs: Ritual, rhs: Ritual) -> Bool {
    if lhs.level < rhs.level {
      return true
    } else if lhs.level == rhs.level {
      return lhs.name < rhs.name
    }
    return false
  }
  
}
