//
//  KnownLoresheetGroupsViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import Foundation

extension KnownLoresheetGroups {
  class ViewModel: BaseKindredViewModel {
    
    let knownLoresheets: [Loresheet]
    
    override init(kindred: Kindred) {
      knownLoresheets = kindred.knownLoresheets
      super.init(kindred: kindred)
    }
    
    /// Fetch all loresheet entries for a particular loresheet that the Kindred prosseses.
    /// - Parameter loresheet: The loresheet in question.
    /// - Returns: All loresheet entries for the loresheet that the Kindred possesses.
    func entries(for loresheet: Loresheet) -> [LoresheetEntry] {
      kindred.entries(for: loresheet)
    }
    
  }
}
