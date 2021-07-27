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
  
  enum Flavor {
    case ritual
    case ceremony
    
    var disciplineName: String {
      switch self {
      case .ritual: return "Blood Sorcery"
      case .ceremony: return "Oblivion"
      }
    }
  }
  
  /// What to call the ritual: "ritual" or "ceremony".
  var flavor: Flavor {
    self.discipline?.name == "Blood Sorcery" ? .ritual : .ceremony
  }
  
}
