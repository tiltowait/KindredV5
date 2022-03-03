//
//  AddDisciplineSheetViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import Foundation

extension AddDisciplineSheet {
  class ViewModel: BaseSavingKindredViewModel {
    
    /// All Disciplines that are in-clan to the character, whether the character knows them or not.
    ///
    /// If the character has no assigned clan, then the value is `nil`.
    var inClanDisciplines: [Discipline]? {
      kindred.clan?.inClanDisciplines
    }
    
    /// All out-of-clan Disciplines the characters knows.
    var knownOutOfClanDisciplines: [Discipline] {
      let inClans = inClanDisciplines ?? []
      let knownDisciplines = kindred.knownDisciplines
      var outOfClan: [Discipline] = []
      
      for discipline in knownDisciplines {
        if !inClans.contains(discipline) {
          outOfClan.append(discipline)
        }
      }
      return outOfClan
    }
    
    /// All Disciplines that are neither in-clan nor known by the character.
    var unknownOutOfClanDisciplines: [Discipline] {
      let allDisciplines = ReferenceManager.shared.disciplines
      let inClan = inClanDisciplines ?? []
      let known = kindred.knownDisciplines
      
      var unknown: [Discipline] = []
      
      for discipline in allDisciplines {
        if !known.contains(discipline) && !inClan.contains(discipline) {
          unknown.append(discipline)
        }
      }
      return unknown
    }
  }
    
}
