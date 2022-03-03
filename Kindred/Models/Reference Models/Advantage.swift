//
//  Advantage.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

class Advantage: InfoItem {
  let id: Int16
  let name: String
  let info: String
  let isBackground: Bool
  
  var allOptions: [AdvantageOption] = []
  
  init(id: Int16, name: String, info: String, isBackground: Bool) {
    self.id = id
    self.name = name
    self.info = info
    self.isBackground = isBackground
  }
}

extension Advantage: Comparable {
  static func <(lhs: Advantage, rhs: Advantage) -> Bool {
    lhs.name < rhs.name
  }
}
