//
//  DisciplineDetailViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import Foundation

extension DisciplineDetail {
  class ViewModel: ObservableObject {
    // We aren't inheriting from BaseKindredViewModel, because we
    // want to have an optional Kindred object. This way, we can
    // use the sheet as either a reference or a place where the
    // user can add powers to their character.
   
    @Published var kindred: Kindred?
    
    let discipline: Discipline
    let availablePowers: [Power]
    let title: String
    let headerText: String
    let icon: String
    
    /// True if the view will be used as a reference tool rather than using it to add powers
    /// to a character.
    let isReferenceView: Bool
    
    /// The first of the available powers.
    var firstAvailablePower: Power {
      availablePowers.first!
    }
    
    init(discipline: Discipline, kindred: Kindred?) {
      self.kindred = kindred
      self.discipline = discipline
      self.title = discipline.name
      self.headerText = discipline.info
      self.icon = discipline.icon
      self.isReferenceView = kindred == nil
      
      // Find out which powers are available
      let powers = discipline.allPowers
      let known = Set(kindred?.knownPowers ?? [])
      var available: [Power] = []
      
      // If we're adding a power to an existing character, we only want to show
      // powers appropriate for their current level. However, we aren't gonig to
      // stop showing powers once they're maxed out, because there may be groups
      // that allow characters, particularly elders, to go above level 5.
      let nextLevel = kindred != nil ? kindred!.level(of: discipline) + 1 : 5
      
      for power in powers {
        if power.level <= nextLevel && !known.contains(power) {
          available.append(power)
        }
      }
      availablePowers = available
    }
    
    /// Add a power to a Kindred.
    ///
    /// This method does not save the changes.
    /// - Parameter power: The power to add.
    func add(power: Power) {
      kindred?.addPower(power)
    }
    
  }
}
