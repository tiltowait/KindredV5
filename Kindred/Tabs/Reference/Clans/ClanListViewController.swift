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
    
    init(kindred: Kindred? = nil, dataController: DataController) {
      self.clans = dataController.clans
      super.init(kindred: kindred, dataController: dataController)
    }
    
  }
}
