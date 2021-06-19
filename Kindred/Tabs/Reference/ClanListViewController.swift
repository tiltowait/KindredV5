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
    
    init(clans: [Clan], kindred: Kindred? = nil, dataController: DataController? = nil) {
      self.clans = clans
      super.init(kindred: kindred, dataController: dataController)
    }
    
  }
}
