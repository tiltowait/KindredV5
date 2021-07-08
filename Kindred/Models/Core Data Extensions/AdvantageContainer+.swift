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
  
  var isBackground: Bool {
    option.parentAdvantage.isBackground
  }
  
  var isFlaw: Bool {
    option.isFlaw
  }
  
  var isMerit: Bool {
    !isBackground && !isFlaw
  }
  
  /// The full name of the contained AdvantageOption, in the format "Advantage, option".
  var fullName:String {
    option.fullName
  }
  
}

extension AdvantageContainer: Comparable {
  
  public static func < (lhs: AdvantageContainer, rhs: AdvantageContainer) -> Bool {
    lhs.option < rhs.option
  }
  
}
