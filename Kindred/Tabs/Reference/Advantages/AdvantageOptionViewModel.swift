//
//  AdvantageOptionViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import Foundation

extension AdvantageOptionView {
  class ViewModel: OptionalKindredViewModel {
    
    enum Status {
      case contained
      case uncontained
      case inapplicable
    }
    
    @Published var option: AdvantageOption
    
    let isSingleOption: Bool
    let singleOptionMagnitude: Int?
    
    var status: Status {
      if dataController != nil {
        if let advantages = kindred?.advantageContainers.map({ $0.option }) {
          if advantages.contains(option) {
            return .contained
          }
          return .uncontained
        }
      }
      return .inapplicable
    }
    
    init(option: AdvantageOption, kindred: Kindred?, dataController: DataController?) {
      self.option = option
      
      isSingleOption = option.minRating == option.maxRating
      singleOptionMagnitude = isSingleOption ? Int(abs(option.maxRating)) : nil
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    func addToCharacter() {
      guard let kindred = kindred,
         let dataController = dataController
      else { return }
      
      let container = AdvantageContainer(context: dataController.container.viewContext)
      container.option = option
      container.currentRating = option.minRating
      kindred.addToAdvantages(container)
    }
    
  }
}
