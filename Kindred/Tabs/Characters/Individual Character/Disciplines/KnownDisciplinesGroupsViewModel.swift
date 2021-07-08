//
//  KnownDisciplinesGroupsViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import CoreData

extension KnownDisciplinesGroups {
  class ViewModel: BaseKindredViewModel {
    
    /// Retrieve the powers the character knows within a Discipline.
    /// - Parameter discipline: The Discipline of interest.
    /// - Returns: The powers from that Discipline the character knows.
    func knownPowers(for discipline: Discipline) -> [Power] {
      kindred.knownPowers.filter { $0.discipline?.id == discipline.id }
    }
    
    /// Remove powers from a given Discipline.
    /// - Parameters:
    ///   - offsets: The index set of powers to remove.
    ///   - discipline: The Discipline from which to remove the powers.
    func removePowers(at offsets: IndexSet, in discipline: Discipline) {
      let powers = knownPowers(for: discipline)
      for offset in offsets {
        let power = powers[offset]
        kindred.removeFromPowers(power)
      }
    }
    
  }
}
