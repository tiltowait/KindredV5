//
//  DiceRollViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import Foundation

extension DiceRollView {
  class ViewModel: BaseKindredViewModel {
    
    @Published var pool = 0
    
    let traitValues: [String: Int]
    var traits: [String] = []
    
    override init(kindred: Kindred) {
      // Initialize the trait values
      var dict: [String: Int] = [:]
      
      let _ = kindred[keyPath: \.academics]
      let keyPaths: [KeyPath<Kindred, Int16>] = [
        \.strength, \.dexterity, \.stamina, \.charisma, \.manipulation, \.composure, \.intelligence,
        \.wits, \.resolve, \.athletics, \.brawl, \.craft, \.drive, \.firearms, \.larceny, \.melee,
        \.stealth, \.survival, \.animalKen, \.etiquette, \.insight, \.intimidation, \.leadership,
        \.performance, \.persuasion, \.streetwise, \.subterfuge, \.academics, \.awareness,
        \.finance, \.investigation, \.medicine, \.occult, \.politics, \.science, \.technology
      ]
      
      for keyPath in keyPaths {
        let trait = keyPath.stringValue.unCamelCased.capitalized
        let value = Int(kindred[keyPath: keyPath])
        dict[trait] = value
      }
      traitValues = dict
      
      super.init(kindred: kindred)
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
