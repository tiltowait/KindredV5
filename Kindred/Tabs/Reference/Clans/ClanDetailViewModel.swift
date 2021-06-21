//
//  ClanDetailViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import Foundation

extension ClanDetail {
  class ViewModel: OptionalKindredViewModel {
    
    let clan: Clan
    
    var selectButtonVisible: Bool {
      kindred != nil && dataController != nil
    }
        
    init(clan: Clan, kindred: Kindred? = nil, dataController: DataController? = nil) {
      self.clan = clan
      super.init(kindred: kindred, dataController: dataController)
    }
    
    /// Assign the modeled Clan to the modeled Kindred.
    func selectClan() {
      kindred?.clan = clan
      NotificationCenter.default.post(name: .didSelectClan, object: nil)
    }
    
  }
}
