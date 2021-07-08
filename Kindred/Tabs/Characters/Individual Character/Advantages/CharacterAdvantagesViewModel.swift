//
//  CharacterAdvantagesViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import Foundation

extension CharacterAdvantages {
  class ViewModel: BaseSavingKindredViewModel {
    
    var hasLoresheets: Bool {
      !kindred.loresheetEntries.isEmpty
    }
   
    var coalesced: [Kindred.CoalescedAdvantage] {
      kindred.coalescedAdvantages
    }
    
    var hasAdvantages: Bool {
      !coalesced.isEmpty || hasLoresheets
    }
    
    func deleteOption(_ offsets: IndexSet, parent coalesced: Kindred.CoalescedAdvantage) {
      for offset in offsets {
        let container = coalesced.containers[offset]
        dataController.delete(container)
      }
    }
    
  }
}
