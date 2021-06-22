//
//  AdvantageContainer+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import Foundation

extension AdvantageContainer {
  
  var option: AdvantageOption {
    get { zOption! }
    set { zOption = newValue }
  }
  
  var advantage: Advantage {
    option.parentAdvantage
  }
  
}

extension AdvantageContainer: Comparable {
  
  public static func < (lhs: AdvantageContainer, rhs: AdvantageContainer) -> Bool {
    lhs.option < rhs.option
  }
  
}
