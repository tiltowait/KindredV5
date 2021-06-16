//
//  DiceRollViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import Foundation

extension DiceRollView {
  class ViewModel: ObservableObject {
    
    @Published var pool = 0
    let kindred: Kindred
    
    let traitValues: [String: Int]
    var traits: [String] = []
    
    init(kindred: Kindred) {
      self.kindred = kindred
      
      // Initialize the trait values
      var dict: [String: Int] = [:]
      
      let _ = kindred[keyPath: \.academics]
      let keyPaths = [
        \Kindred.strength, \Kindred.dexterity, \Kindred.stamina, \Kindred.charisma, \Kindred.manipulation,
        \Kindred.composure, \Kindred.intelligence, \Kindred.wits, \Kindred.resolve, \Kindred.athletics,
        \Kindred.brawl, \Kindred.craft, \Kindred.drive, \Kindred.firearms, \Kindred.larceny, \Kindred.melee,
        \Kindred.stealth, \Kindred.survival, \Kindred.animalKen, \Kindred.etiquette, \Kindred.insight,
        \Kindred.intimidation, \Kindred.leadership, \Kindred.performance, \Kindred.persuasion,
        \Kindred.streetwise, \Kindred.subterfuge, \Kindred.academics, \Kindred.awareness, \Kindred.finance,
        \Kindred.investigation, \Kindred.medicine, \Kindred.occult, \Kindred.politics, \Kindred.science,
        \Kindred.technology
      ]
      
      for keyPath in keyPaths {
        let trait = keyPath.stringValue.unCamelCased.capitalized
        let value = Int(kindred[keyPath: keyPath])
        dict[trait] = value
      }
      traitValues = dict
    }
    
    func toggle(_ trait: String) {
      if let index = traits.firstIndex(of: trait) {
        traits.remove(at: index)
        pool -= traitValues[trait]!
      } else {
        traits.append(trait)
        pool += traitValues[trait]!
      }
    }
    
    // MARK: - Dice Columns
    
    let attributeColumns = [
      [
        "Strength",
        "Dexterity",
        "Stamina"
      ],
      [
        "Charisma",
        "Manipulation",
        "Composure"
      ],
      [
        "Intelligence",
        "Wits",
        "Resolve"
      ]
    ]
    
    let skillColumns = [
      [
        "Athletics",
        "Brawl",
        "Craft",
        "Drive",
        "Firearms",
        "Larceny",
        "Melee",
        "Stealth",
        "Survival"
      ],
      [
        "AnimalKen",
        "Etiquette",
        "Insight",
        "Intimidation",
        "Leadership",
        "Performance",
        "Persuasion",
        "Streetwise",
        "Subterfuge"
      ],
      [
        "Academics",
        "Awareness",
        "Finance",
        "Investigation",
        "Medicine",
        "Occult",
        "Politics",
        "Science",
        "Technology"
      ]
    ]
    
  }
}
