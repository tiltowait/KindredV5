//
//  BloodPotency.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/8/21.
//

import Foundation

/// A structure containing all the costs and benefits for a character's blood potency.
struct BloodPotency {
  
  let potency: Int
  let mend: Int
  let surge: Int
  let powerBonus: Int?
  let rouseReroll: Int?
  let baneSeverity: Int
  let penalty: String
  
  init(_ potency: Int16) {
    self.potency = Int(potency)
    
    switch potency {
    case 0:
      surge = 1
      mend = 1
      powerBonus = nil
      rouseReroll = nil
      baneSeverity = 0
      penalty = "No effect"
    case 1:
      surge = 2
      mend = 1
      powerBonus = nil
      rouseReroll = 1
      baneSeverity = 2
      penalty = "No effect"
    case 2:
      surge = 2
      mend = 2
      powerBonus = 1
      rouseReroll = 1
      baneSeverity = 2
      penalty = "Animal and bagged blood slake half hunger"
    case 3:
      surge = 3
      mend = 2
      powerBonus = 1
      rouseReroll = 2
      baneSeverity = 3
      penalty = "Animal and bagged blood slake no hunger."
    case 4:
      surge = 3
      mend = 3
      powerBonus = 2
      rouseReroll = 2
      baneSeverity = 3
      penalty = "Animal and bagged blood slake no hunger. Slake 1 less hunger per human."
    case 5:
      surge = 4
      mend = 3
      powerBonus = 2
      rouseReroll = 3
      baneSeverity = 4
      penalty = "Animal and bagged blood slake no hunger. Slake 1 less hunger per human. Must drain and kill a human to reduce hunger below 2."
    case 6:
      surge = 4
      mend = 3
      powerBonus = 3
      rouseReroll = 3
      baneSeverity = 4
      penalty = "Animal and bagged blood slake no hunger. Slake 2 less hunger per human. Must drain and kill a human to reduce hunger below 2."
    case 7:
      surge = 5
      mend = 3
      powerBonus = 3
      rouseReroll = 3
      baneSeverity = 5
      penalty = "Animal and bagged blood slake no hunger. Slake 2 less hunger per human. Must drain and kill a human to reduce hunger below 2."
    case 8:
      surge = 5
      mend = 4
      powerBonus = 4
      rouseReroll = 4
      baneSeverity = 5
      penalty = "Animal and bagged blood slake no hunger. Slake 2 less hunger per human. Must drain and kill a human to reduce hunger below 3."
    case 9:
      surge = 6
      mend = 4
      powerBonus = 4
      rouseReroll = 5
      baneSeverity = 6
      penalty = "Animal and bagged blood slake no hunger. Slake 2 less hunger per human. Must drain and kill a human to reduce hunger below 3."
    default:
      surge = 6
      mend = 5
      powerBonus = 5
      rouseReroll = 5
      baneSeverity = 6
      penalty = "Animal and bagged blood slake no hunger. Slake 3 less hunger per human. Must drain and kill a human to reduce hunger below 3."
    }
  }
  
  var surgeString: String {
    "Add \(surge) die"
  }
  
  var mendString: String {
    "\(mend) point of superficial damage"
  }
  
  var powerBonusString: String {
    if let powerBonus = powerBonus {
      return "Add \(powerBonus) die"
    }
    return "None"
  }
  
  var rouseRerollString: String {
    if let rouseReroll = rouseReroll {
      return "Add \(rouseReroll) die"
    }
    return "None"
  }
  
}
