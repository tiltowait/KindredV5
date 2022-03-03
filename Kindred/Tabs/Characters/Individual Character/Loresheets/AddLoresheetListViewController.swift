//
//  AddLoresheetListViewController.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import Foundation

extension AddLoresheetList {
  class ViewModel: BaseKindredViewModel {
    
    let knownLoresheets: [Loresheet]
    let unknownLoresheets: [Loresheet]
    
    init(kindred: Kindred, dataController: DataController) {
      knownLoresheets = kindred.knownLoresheets
      
      var unknownLoresheets = ReferenceManager.shared.loresheets
      for knownLoresheet in knownLoresheets {
        unknownLoresheets.removeAll { $0 == knownLoresheet }
      }
      self.unknownLoresheets = unknownLoresheets.sorted()
      
      super.init(kindred: kindred)
    }
    
  }
}
