//
//  CharacterDetailViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

extension CharacterDetail {
  class ViewModel: BaseSavingKindredViewModel {
    
    private(set) lazy var clans: [Clan] = {
      dataController.clans
    }()
    
    @Published var clanName: String
    
    /// True if the referenced character knows no Discipline.
    var noKnownDisciplines: Bool {
      kindred.knownDisciplines.isEmpty
    }
    
    var zippedAttributes: [[(String, Int16)]] {
      [
        [
          ("Strength", kindred.strength),
          ("Dexterity", kindred.dexterity),
          ("Stamina", kindred.stamina)
        ],
        [
          ("Charisma", kindred.charisma),
          ("Manipulation", kindred.manipulation),
          ("Composure", kindred.composure)
        ],
        [
          ("Intelligence", kindred.intelligence),
          ("Wits", kindred.wits),
          ("Resolve", kindred.resolve)
        ]
      ]
    }
    
    var zippedAbilities: [[(String, Int16)]] {
      [
        [
          ("Athletics", kindred.athletics),
          ("Brawl", kindred.brawl),
          ("Craft", kindred.craft),
          ("Drive", kindred.drive),
          ("Firearms", kindred.firearms),
          ("Larceny", kindred.larceny),
          ("Melee", kindred.melee),
          ("Stealth", kindred.stealth),
          ("Survival", kindred.survival),
        ],
        [
          ("Animal Ken", kindred.animalKen),
          ("Etiquette", kindred.etiquette),
          ("Insight", kindred.insight),
          ("Intimidation", kindred.intimidation),
          ("Leadership", kindred.leadership),
          ("Perform", kindred.performance),
          ("Persuasion", kindred.persuasion),
          ("Streetwise", kindred.streetwise),
          ("Subterfuge", kindred.subterfuge),
        ],
        [
          ("Academics", kindred.academics),
          ("Awareness", kindred.awareness),
          ("Finance", kindred.finance),
          ("Investigation", kindred.investigation),
          ("Medicine", kindred.medicine),
          ("Occult", kindred.occult),
          ("Politics", kindred.politics),
          ("Science", kindred.science),
          ("Technology", kindred.technology)
        ]
      ]
    }
    
    override init(kindred: Kindred, dataController: DataController) {
      clanName = kindred.clan?.name ?? "Tap to select"
      super.init(kindred: kindred, dataController: dataController)
      
      NotificationCenter.default.addObserver(self, selector: #selector(clanWasSelected), name: .didSelectClan, object: nil)
    }
    
    /// Inform the view model the clan was changed so that CharacterDetail can update its relevant fields.
    /// - Parameter notification: The clan selection notification.
    @objc func clanWasSelected(_ notification: Notification) {
      // All CharacterDetailViewModels receive this notification. Because of this, we must use
      // nil coalescing, or the app will crash if the user has more than one character with no
      // defined clan
      clanName = kindred.clan?.name ?? "Tap to select"
    }
    
  }
}

extension Notification.Name {
  
  static let didSelectClan = Notification.Name("didSelectClan")
  
}
