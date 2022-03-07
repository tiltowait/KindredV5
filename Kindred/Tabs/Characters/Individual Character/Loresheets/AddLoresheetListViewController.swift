//
//  AddLoresheetListViewController.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import Foundation

extension AddLoresheetList {
  class ViewModel: BaseSavingKindredViewModel {
    
    @Published var unlockIdentifier: String?
    
    let knownLoresheets: [Loresheet]
    let unknownLoresheets: [Loresheet]
    
    override init(kindred: Kindred, dataController: DataController) {
      knownLoresheets = kindred.knownLoresheets
      
      var unknownLoresheets = ReferenceManager.shared.loresheets
      for knownLoresheet in knownLoresheets {
        unknownLoresheets.removeAll { $0 == knownLoresheet }
      }
      self.unknownLoresheets = unknownLoresheets.sorted()
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    func isUnlocked(loresheet: Loresheet) -> Bool {
      dataController.isPurchased(item: loresheet)
    }
    
  }
}
