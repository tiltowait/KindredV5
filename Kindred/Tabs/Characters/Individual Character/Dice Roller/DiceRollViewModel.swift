//
//  DiceRollViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import Foundation

extension DiceRollView {
  class ViewModel: ObservableObject {
    
    @Published var showingAttributes = true
    @Published var showingSkills = false
    @Published var showingDisciplines = false
    
    @Published var pool = 0
    @Published var bonusDice: Int16 = 0
    
    let traitValues: [String: Int]
    @Published var selectedTraits: [String] = []
    
    private var hasShownSkills = false
    
    init(kindred: Kindred) {
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
      
      // Figure out the discipline columns and values
      let knownDisciplines = kindred.knownDisciplines
      var disciplineNames: [String] = []
      
      for discipline in knownDisciplines {
        let level = kindred.level(of: discipline)
        let name = discipline.name
        
        dict[name] = level
        disciplineNames.append(name)
      }
      
      print(disciplineNames)
      let numRows = Int(ceil(Double(disciplineNames.count) / 3))
      print(numRows)
      var disciplineColumns: [[String]] = []
      repeat {
        let row = disciplineNames.first(numRows)
        print(row)
        disciplineNames.removeFirst(numRows.clamp(low: 0, high: disciplineNames.count))
        print(disciplineNames)
        disciplineColumns.append(row)
      } while !disciplineNames.isEmpty
      
      self.disciplineColumns = disciplineColumns
      
      traitValues = dict
    }
    
    func toggleAttribute(_ attribute: String) {
      toggle(attribute)

      // 99% of the time, the user will only want to select one
      // attribute and one skill, so let's go ahead and handle
      // the expansion of the appropriate groups.
      
      if !hasShownSkills {
        showingAttributes = false
        showingSkills = true
        hasShownSkills = true
      }
    }
    
    func toggleSkill(_ skill: String) {
      toggle(skill)
    }
    
    func deselectTrait(_ trait: String) {
      toggle(trait)
    }
    
    /// Reset everything to the initial state.
    func reset() {
      selectedTraits.removeAll()
      hasShownSkills = false
      showingSkills = false
      showingAttributes = true
      showingDisciplines = false
    }
    
    private func toggle(_ trait: String) {
      if let index = selectedTraits.firstIndex(of: trait) {
        selectedTraits.remove(at: index)
        pool -= traitValues[trait]!
      } else {
        selectedTraits.append(trait)
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
        "Animal Ken",
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
    
    let disciplineColumns: [[String]]
    
  }
}
