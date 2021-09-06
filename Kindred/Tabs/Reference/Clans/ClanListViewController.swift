//
//  ClanListViewController.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import Foundation

extension ClanList {
  class ViewModel: OptionalKindredViewModel {
    
    let clans: [Clan]
    let showCancelButton: Bool
    
    init(kindred: Kindred? = nil, dataController: DataController) {
      self.clans = dataController.clans
      showCancelButton = kindred != nil
      super.init(kindred: kindred, dataController: dataController)
    }
    
    func isUnlocked(clan: Clan) -> Bool {
      dataController!.isPurchased(identifier: clan.sourceBook.unlockIdentifier)
    }
    
  }
}
