//
//  CharacterRitualsListViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 8/2/21.
//

import Foundation

extension CharacterRitualsList {
  class ViewModel: BaseSavingKindredViewModel {
    
    var availableSchools: [Ritual.Flavor] {
      kindred.availableRitualSchools
    }
    
    override init(kindred: Kindred, dataController: DataController) {
      super.init(kindred: kindred, dataController: dataController)
      NotificationCenter.default.addObserver(self, selector: #selector(ritualAdded), name: .didAddRitual, object: nil)
    }
    
    /// Generate a section title for a school.
    /// - Parameter school: The school.
    /// - Returns: The generated title.
    func sectionTitle(school: Ritual.Flavor) -> String {
      switch school {
      case .ritual:
        return "Blood Sorcery Rituals"
      case .ceremony:
        return "Oblivion Ceremonies"
      case .formula:
        return "Alchemical Formulae"
      }
    }
    
    /// Fetch the rituals of a particular school known to the character.
    /// - Parameter school: The school of rituals.
    /// - Returns: The known rituals of that school.
    func rituals(forSchool school: Ritual.Flavor) -> [Ritual] {
      kindred.knownRituals.filter { $0.flavor == school }
    }
    
    /// Remove rituals from a character.
    /// - Parameters:
    ///   - school: The school in which the ritual exists.
    ///   - offsets: The rituals' list indices.
    func removeRituals(school: Ritual.Flavor, offsets: IndexSet) {
      self.objectWillChange.send()
      
      let rituals = kindred.knownRituals.filter { $0.flavor == school }
      for offset in offsets {
        let ritual = rituals[offset]
        kindred.removeRitual(ritual)
      }
    }
    
    @objc func ritualAdded(_ notification: Notification) {
      self.objectWillChange.send()
    }
  }
}

extension Notification.Name {
  static let didAddRitual = Notification.Name("didAddRitual")
}
