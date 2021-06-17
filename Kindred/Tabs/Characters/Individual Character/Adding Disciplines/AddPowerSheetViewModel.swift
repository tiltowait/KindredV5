//
//  AddPowerSheetViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import Foundation

extension AddPowerSheet {
  class ViewModel: BaseSavingKindredViewModel {
   
    let discipline: Discipline
    let availablePowers: [Power]
    let title: String
    
    /// The first of the available powers.
    var firstAvailablePower: Power {
      availablePowers.first!
    }
    
    init(discipline: Discipline, kindred: Kindred, dataController: DataController) {
      self.discipline = discipline
      self.title = discipline.name
      
      // Find out which powers are available
      let powers = discipline.allPowers
      let known = kindred.knownPowers
      var available: [Power] = []
      
      for power in powers {
        if !known.contains(power) {
          available.append(power)
        }
      }
      availablePowers = available
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    /// Add a power to a Kindred.
    ///
    /// This method does not save the changes.
    /// - Parameter power: The power to add.
    func add(power: Power) {
      kindred.addToPowers(power)
    }
    
  }
}
