//
//  ClanDetailViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import Foundation

extension ClanDetail {
  class ViewModel: OptionalKindredViewModel {
    
    @Published var clan: Clan
    let reselection: (() -> Void)?
    
    /// Whether to show the "Select Clan" button; applies when the clan is NOT set.
    var selectButtonVisible: Bool {
      return kindred != nil && reselection == nil
    }
    
    
    /// Whether to show the "Change Clan" button; applies when the clan IS set.
    var reselectButtonVisible: Bool {
      reselection != nil && kindred != nil
    }
    
    /// Create a new view model.
    /// - Parameters:
    ///   - clan: The clan to display.
    ///   - kindred: Optionally, a Kindred to which to apply a clan.
    ///   - reselection: Optionally, a completion handler for showing the clan selection sheet.
    init(clan: Clan, kindred: Kindred?, reselection: (() -> Void)?) {
      self.clan = clan
      self.reselection = reselection
      super.init(kindred: kindred, dataController: nil)
      
      NotificationCenter.default.addObserver(self, selector: #selector(clanWasSelected), name: .didSelectClan, object: nil)
    }
    
    /// Assign the modeled Clan to the modeled Kindred.
    func selectClan() {
      kindred?.clan = clan
      NotificationCenter.default.post(name: .didSelectClan, object: nil)
    }
    
    /// Change the displayed clan to the selected one.
    /// - Parameter notification: The notification calling this method.
    @objc func clanWasSelected(_ notification: Notification) {
      if let clan = kindred?.clan {
        self.clan = clan
      }
    }
    
  }
}
