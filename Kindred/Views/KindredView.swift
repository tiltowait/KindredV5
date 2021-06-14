//
//  KindredView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

// TODO: Create view model

import SwiftUI

struct KindredView: View {
  
  let kindred: Kindred
  
  var body: some View {
    List {
      Section(header: Text("12th-generation Hecata in Cape Town by Night")) { // Placeholder
        BoldLabelView(label: "Ambition", details: kindred.ambition)
        BoldLabelView(label: "Desire", details: kindred.desire)
      }
      
      Section(header: Text("Traits")) {
        NavigationLink(destination: Text("Attributes")) {
          TraitBlockView(title: "Attributes", traits: zippedAttributes)
        }
        NavigationLink(destination: Text("Abilities")) {
          TraitBlockView(title: "Abilities", traits: zippedAbilities)
        }
      }
      
    }
    .listStyle(GroupedListStyle())
    .navigationTitle(kindred.name)
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

//struct KindredView_Previews: PreviewProvider {
//  static var previews: some View {
//    KindredView(kindred: Kindred.example)
//  }
//}
