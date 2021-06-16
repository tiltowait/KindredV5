//
//  KindredViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

extension KindredView {
  class ViewModel: BaseSavingKindredViewModel {
    
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
          ("Performance", kindred.performance),
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
    
  }
}
