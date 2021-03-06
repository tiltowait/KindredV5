//
//  Ritual.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

final class Ritual: ReferenceItem {
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
    
    var plural: String {
      switch self {
      case .ritual:
        return "Rituals"
      case .ceremony:
        return "Ceremonies"
      case .formula:
        return "Formulae"
      }
    }
  }

  let id: Int16
  let name: String
  let info: String
  let page: Int16
  let source: Int16
  
  let duration: String?
  let ingredients: String?
  let level: Int16
  let process: String
  let system: String
  
  let discipline: Discipline
  let prerequisite: Power?
  
  var flavor: Flavor {
    switch self.discipline.name {
    case "Blood Sorcery":
      return .ritual
    case "Oblivion":
      return .ceremony
    default:
      return .formula
    }
  }
  
  init(id: Int16, name: String, info: String, page: Int16, source: Int16, duration: String?, ingredients: String?, level: Int16, process: String, system: String, discipline: Discipline, prerequisite: Power?) {
    self.id = id
    self.name = name
    self.info = info
    self.page = page
    self.source = source
    self.duration = duration
    self.ingredients = ingredients
    self.level = level
    self.process = process
    self.system = system
    self.discipline = discipline
    self.prerequisite = prerequisite
  }
}

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

extension Ritual: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}

extension Ritual {
  static let unknown = Ritual(id: -1, name: "Unknown", info: "Update your app to the latest version.", page: 0, source: 0, duration: nil, ingredients: nil, level: 1, process: "Unknown.", system: "Unknown.", discipline: Discipline.unknown, prerequisite: nil)
}
