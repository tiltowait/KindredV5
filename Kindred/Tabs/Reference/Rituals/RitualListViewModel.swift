//
//  RitualListViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 8/2/21.
//

import Foundation
import CoreData

extension RitualList {
  class ViewModel: OptionalKindredViewModel {
    
    let title: String
    let rituals: [Int: [Ritual]]
    let isReferenceView: Bool
    
    init(flavor: Ritual.Flavor, kindred: Kindred?, dataController: DataController) {
      let request: NSFetchRequest<Ritual> = Ritual.fetchRequest()
      request.predicate = NSPredicate(format: "discipline.zName == %@", flavor.disciplineName)
      request.sortDescriptors = [
        NSSortDescriptor(keyPath: \Ritual.level, ascending: true),
        NSSortDescriptor(keyPath: \Ritual.zName, ascending: true)
      ]
      
      var allRituals = dataController.fetch(request: request)
      if let kindred = kindred {
        // Remove known rituals
        allRituals = allRituals.filter { !kindred.knownRituals.contains($0) }
      }
      
      var groupedRituals: [Int: [Ritual]] = [:]
      
      // Rituals range from level 1 to level 5
      for level in 1...5 {
        let filtered = allRituals.filter { $0.level == level }
        groupedRituals[level] = filtered
      }
      
      self.title = flavor == .ritual ? "Blood Sorcery Rituals" : "Oblivion Ceremonies"
      self.rituals = groupedRituals
      self.isReferenceView = kindred == nil
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    func add(ritual: Ritual) {
      kindred?.addToRituals(ritual)
    }
    
  }
}
