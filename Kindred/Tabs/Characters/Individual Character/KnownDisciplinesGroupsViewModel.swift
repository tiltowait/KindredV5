//
//  KnownDisciplinesGroupsViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import CoreData

extension KnownDisciplinesGroups {
  class ViewModel: BaseSavingKindredViewModel {
    
    var noKnownDisciplines: Bool {
      kindred.knownDisciplines.isEmpty
    }
    
    func knownPowers(forDiscipline discipline: Discipline) -> [Power] {
      kindred.knownPowers.filter { $0.discipline?.id == discipline.id }
    }
    
  }
}
