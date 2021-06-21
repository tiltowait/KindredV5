//
//  AdvantageOptionViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import Foundation

extension AdvantageOptionView {
  class ViewModel: OptionalKindredViewModel {
    
    @Published var option: AdvantageOption
    
    let isSingleOption: Bool
    let singleOptionMagnitude: Int?
    
    init(option: AdvantageOption) {
      self.option = option
      isSingleOption = option.minRating == option.maxRating
      singleOptionMagnitude = isSingleOption ? Int(abs(option.maxRating)) : nil
      
      super.init(kindred: nil, dataController: nil) // TODO: Finish later
    }
    
  }
}
