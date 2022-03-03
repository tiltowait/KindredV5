//
//  AdvantageListViewController.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import Foundation

extension AdvantageList {
  class ViewModel: OptionalKindredViewModel {
    
    let merits: [Advantage]
    let backgrounds: [Advantage]
    
    init(kindred: Kindred?, dataController: DataController) {
      merits = ReferenceManager.shared.advantages.filter { $0.isBackground == false }
      backgrounds = ReferenceManager.shared.advantages.filter { $0.isBackground }
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    override init(kindred: Kindred?, dataController: DataController?) {
      fatalError("A data controller must be supplied.")
    }
    
  }
}
