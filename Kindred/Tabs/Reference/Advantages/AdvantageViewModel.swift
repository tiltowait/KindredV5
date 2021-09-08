//
//  AdvantageViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import Foundation

extension AdvantageView {
  class ViewModel: OptionalKindredViewModel {

    let advantage: Advantage
    let title: String
    
    let merits: [AdvantageOption]
    let flaws: [AdvantageOption]
    
    init(advantage: Advantage, kindred: Kindred?, dataController: DataController) {
      self.advantage = advantage
      self.title = advantage.name
      
      let options = advantage.allOptions
      merits = options.filter { !$0.isFlaw }
      flaws = options.filter { $0.isFlaw }
      super.init(kindred: kindred, dataController: dataController)
    }
    
  }
}
