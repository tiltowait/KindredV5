//
//  CharacterAdvantagesViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import Foundation

extension CharacterAdvantages {
  class ViewModel: BaseSavingKindredViewModel {
   
    var coalesced: [Kindred.CoalescedAdvantage] {
      kindred.coalescedAdvantages
    }
    
    func deleteOption(_ offsets: IndexSet, parent coalesced: Kindred.CoalescedAdvantage) {
      for offset in offsets {
        let container = coalesced.containers[offset]
        dataController.delete(container)
      }
    }
    
  }
}
