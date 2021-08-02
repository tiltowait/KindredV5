//
//  CharacterRitualsListViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 8/2/21.
//

import Foundation

extension CharacterRitualsList {
  class ViewModel: BaseSavingKindredViewModel {
    
    /// The rituals known by the character.
    var rituals: [Ritual] {
      kindred.knownRituals.filter { $0.flavor == .ritual }
    }
    
    /// The ceremonies known by the character.
    var ceremonies: [Ritual] {
      kindred.knownRituals.filter { $0.flavor == .ceremony }
    }
    
  }
}
