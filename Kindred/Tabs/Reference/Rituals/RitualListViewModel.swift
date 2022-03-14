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
    
    @Published var lockedRitual: String?
    
    init(flavor: Ritual.Flavor, kindred: Kindred?, dataController: DataController) {
      var allRituals = ReferenceManager.shared.rituals.filter { $0.discipline.name == flavor.disciplineName }
      /*
      let request: NSFetchRequest<Ritual> = Ritual.fetchRequest()
      request.predicate = NSPredicate(format: "discipline.zName == %@", flavor.disciplineName)
      request.sortDescriptors = [
        NSSortDescriptor(keyPath: \Ritual.level, ascending: true),
        NSSortDescriptor(keyPath: \Ritual.zName, ascending: true)
      ]
       */
      
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
      
      switch flavor {
      case .ritual: self.title = "Blood Sorcery Rituals"
      case .ceremony: self.title = "Oblivion Ceremonies"
      case.formula: self.title = "Alchemy Formulae"
      }
      self.rituals = groupedRituals
      self.isReferenceView = kindred == nil
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    /// A list of rituals for a given level.
    /// - Parameter level: The level of rituals to get
    /// - Returns: The rituals for that level, or nil if there aren't any.
    func rituals(level: Int) -> [Ritual]? {
      let rituals = self.rituals[level] ?? []
      return rituals.isEmpty ? nil : rituals
    }
    
    func add(ritual: Ritual) {
      kindred?.addRitual(ritual)
      NotificationCenter.default.post(name: .didAddRitual, object: nil)
    }
    
    func isUnlocked(ritual: Ritual) -> Bool {
      dataController!.isPurchased(item: ritual)
    }
    
  }
}
