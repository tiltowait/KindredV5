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
    
    init(loresheet: Loresheet, kindred: Kindred?) {
      self.loresheet = loresheet
      super.init(kindred: kindred, dataController: nil)
    }
    
  }
}
