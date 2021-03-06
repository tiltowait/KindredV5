//
//  AdvantageOption.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

final class AdvantageOption: ReferenceItem {
  let id: Int16
  let name: String
  let info: String
  let page: Int16
  let source: Int16
  let maxRating: Int16
  let minRating: Int16
  
  let parentAdvantage: Advantage
  
  var isFlaw: Bool { minRating < 0 && maxRating < 0 }
  var fullName: String {
    if parentAdvantage.name != name {
      return "\(parentAdvantage.name), \(name)"
    }
    return name
  }
  
  init(id: Int16, name: String, info: String, page: Int16, source: Int16, minRating: Int16, maxRating: Int16, parentAdvantage: Advantage) {
    self.id = id
    self.name = name
    self.info = info
    self.page = page
    self.source = source
    self.minRating = minRating
    self.maxRating = maxRating
    self.parentAdvantage = parentAdvantage
  }
  
}

extension AdvantageOption: Comparable {
  static func < (lhs: AdvantageOption, rhs: AdvantageOption) -> Bool {
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

extension AdvantageOption {
  static let unknown = AdvantageOption(id: -1, name: "Unknown", info: "Update your app to the latest version.", page: 0, source: 0, minRating: 1, maxRating: 1, parentAdvantage: Advantage.unknown)
}
