//
//  LoresheetEntryDetailViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import Foundation

extension LoresheetEntryDetail {
  class ViewModel: OptionalKindredViewModel {
    
    enum ButtonToShow {
      case add
      case have
      case none
    }
    
    let entry: LoresheetEntry
    let buttonToShow: ButtonToShow
    
    init(entry: LoresheetEntry, kindred: Kindred?) {
      self.entry = entry
      
      if let kindred = kindred {
        buttonToShow = kindred.loresheetEntries.contains(entry) ? .have : .add
      } else {
        buttonToShow = .none
      }
      
      super.init(kindred: kindred, dataController: nil)
    }
    
    func addToKindred() {
      kindred?.addToLoresheets(entry)
    }
    
  }
}
