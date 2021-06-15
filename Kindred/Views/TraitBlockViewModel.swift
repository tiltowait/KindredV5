//
//  TraitBlockViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

extension TraitBlockView {
  class ViewModel: BaseKindredViewModel {
    
    enum TraitGroup: String {
      case attributes
      case skills
    }
    
    let traits: TraitGroup
    
    init(kindred: Kindred, dataController: DataController, traits: TraitGroup) {
      self.traits = traits
      super.init(kindred: kindred, dataController: dataController)
    }
    
    var title: String {
      traits.rawValue.capitalized
    }
    
    var costToIncrease: String {
      let cost = traits == .attributes ? 5 : 3
      return "Cost to increase: New Level × \(cost)"
    }
    
    var physical: [ReferenceWritableKeyPath<Kindred, Int16>] {
      if traits == .skills {
        return [
          \Kindred.athletics,
          \Kindred.brawl,
          \Kindred.craft,
          \Kindred.drive,
          \Kindred.firearms,
          \Kindred.larceny,
          \Kindred.melee,
          \Kindred.stealth,
          \Kindred.survival
        ]
      } else {
        return [
          \Kindred.strength,
          \Kindred.dexterity,
          \Kindred.stamina
        ]
      }
    }
    
    var social: [ReferenceWritableKeyPath<Kindred, Int16>] {
      if traits == .skills {
        return [
          \Kindred.animalKen,
          \Kindred.etiquette,
          \Kindred.insight,
          \Kindred.intimidation,
          \Kindred.leadership,
          \Kindred.performance,
          \Kindred.persuasion,
          \Kindred.streetwise,
          \Kindred.subterfuge
        ]
      } else {
        return [
          \Kindred.charisma,
          \Kindred.manipulation,
          \Kindred.composure
        ]
      }
    }
    
    var mental: [ReferenceWritableKeyPath<Kindred, Int16>] {
      if traits == .skills {
        return [
          \Kindred.academics,
          \Kindred.awareness,
          \Kindred.finance,
          \Kindred.investigation,
          \Kindred.medicine,
          \Kindred.occult,
          \Kindred.politics,
          \Kindred.science,
          \Kindred.technology
        ]
      } else {
        return  [
          \Kindred.intelligence,
          \Kindred.wits,
          \Kindred.resolve
        ]
      }
    }
    
    func reference(forKeyPath keyPath: KeyPath<Kindred, Int16>) -> String {
      dataController.traitReference[keyPath.stringValue.unCamelCased.capitalized] ?? ""
    }
    
  }
}
