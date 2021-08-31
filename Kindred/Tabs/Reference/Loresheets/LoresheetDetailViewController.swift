//
//  LoresheetDetailViewController.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import Foundation

extension LoresheetDetail {
  class ViewModel: OptionalKindredViewModel {
    
    @Published var loresheet: Loresheet
    
    var clanRestrictions: String? {
      if let clans = loresheet.clanRestrictions?.map({ $0.name }) {
        return clans.joined(separator: ", ")
      }
      return nil
    }
    
    init(loresheet: Loresheet, kindred: Kindred?) {
      self.loresheet = loresheet
      super.init(kindred: kindred, dataController: nil)
    }
    
  }
}
