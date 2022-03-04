//
//  Examples.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/16/21.
//
//  This file stores example members for the various Core Data types.
//  Used only for development/testing, they are not included in the
//  final release build.

import UIKit

extension Advantage {
  
  static var example: Advantage {
    ReferenceManager.shared.advantages[1]
  }
  
}

extension Clan {
  
  /// The example clan.
  static var example: Clan {
    ReferenceManager.shared.clans[0]
  }
}

extension Discipline {
  
  /// The example Discipline (Animalism).
  static var example: Discipline {
    ReferenceManager.shared.disciplines[0]
  }
  
}

extension Power {
  
  /// The example Power (Quell the Beast, Animalism •••).
  static var example: Power {
    ReferenceManager.shared.power(named: "Aura of Decay")!
  }
  
}

extension Kindred {
  
  /// An example Kindred used for testing purposes.
  static var example: Kindred {
    let dataController = DataController.preview
    let kindred = Kindred(context: dataController.container.viewContext)
    kindred.name = "Nadea Theron"
    kindred.concept = "Bahari ER Surgeon"
    kindred.ambition = "Attain mastery over Oblivion"
    kindred.desire = "Induct her ghoul into the faith"
    kindred.chronicle = "Cape Town by Night"
    kindred.weight = "115 lbs"
    kindred.height = "5'6\""
    kindred.generation = 12
    
    // Make birthdate and embrace date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    kindred.birthdate = dateFormatter.date(from: "1982/03/17")!
    kindred.embraceDate = dateFormatter.date(from: "2009/06/21")!
    kindred.inGameDate = dateFormatter.date(from: "2021/06/12")!
    
    kindred.sire = "Vivette de Klerk"
    
    KindredImage.examples.forEach { kindred.addToImages($0) }
    
    // Set some traits
    kindred.strength = 3
    kindred.dexterity = 2
    kindred.stamina = 3
    kindred.charisma = 1
    kindred.manipulation = 2
    kindred.composure = 2
    kindred.intelligence = 3
    kindred.wits = 2
    kindred.resolve = 4
    kindred.athletics = 2
    kindred.brawl = 3
    kindred.larceny = 1
    kindred.stealth = 1
    kindred.etiquette = 1
    kindred.insight = 1
    kindred.intimidation = 2
    kindred.streetwise = 1
    kindred.subterfuge = 1
    kindred.academics = 2
    kindred.awareness = 1
    kindred.investigation = 2
    kindred.medicine = 3
    kindred.occult = 3
    kindred.science = 2
    
    kindred.health = 8
    kindred.willpower = 6
    kindred.humanityString = "ooooooo../"
    kindred.bloodPotency = 1
    kindred.hunger = 2
    
    kindred.clan = Clan.example
    
    // Add some Disciplines
    kindred.addPower(Power.example)
    
    // Add some advantages
    let advantageNames = ["Stunning", "Archaic", "Bond Junkie", "Bond Resistance", "Short Bond", "Organovore"]
    for name in advantageNames {
      let container = AdvantageContainer(context: dataController.container.viewContext)
      container.refID = ReferenceManager.shared.advantageOption(named: name)!.id
      container.currentRating = container.option.minRating
      kindred.addToAdvantages(container)
    }
    
    // Add some loresheets
    kindred.addLoresheetEntry(ReferenceManager.shared.loresheetEntry(named: "Dangerous Reputation")!)
    kindred.addLoresheetEntry(ReferenceManager.shared.loresheetEntry(named: "First-Cursed")!)
    kindred.addLoresheetEntry(ReferenceManager.shared.loresheetEntry(named: "Book of the Grave-War")!)
    kindred.addLoresheetEntry(ReferenceManager.shared.loresheetEntry(named: "Trophy Kill")!)
    kindred.addLoresheetEntry(ReferenceManager.shared.loresheetEntry(named: "Herd Mindset")!)
    
    // Set some biographical detail
    kindred.appearance = "An unkempt hunchback with heterochromia."
    kindred.distinguishingFeatures = "A tattoo of a third eye on her forehead."
    kindred.history = "She once went to the market."
    kindred.possessions = "A tent and a dream."
    kindred.notes = "This is a fake character."
    
    // Set some specialties
    let specialty = Specialty(context: dataController.container.viewContext)
    specialty.skill = "Occult"
    specialty.specialties = ["Grave Rituals", "Summoning"]
    specialty.parent = kindred
    
    return kindred
  }
  
}

extension KindredImage {
  
  static var examples: [KindredImage] {
    let imageNames = ["nadea", "nadea-portrait"]
    var images: [KindredImage] = []
    var creationOffset: TimeInterval = -1 // One image's creation date should be before the other
    
    for imageName in imageNames {
      let ki = KindredImage(context: DataController.preview.container.viewContext)
      let url = Bundle.main.url(forResource: imageName, withExtension: "png")!
      
      ki.imageURL = url
      ki.thumbnailURL = url
      ki.creationDate = Date(timeIntervalSinceNow: creationOffset)
      creationOffset += 1
      
      images.append(ki)
    }
    return images
  }
  
}

extension Loresheet {
  
  static var example: Loresheet {
    ReferenceManager.shared.loresheet(named: "Occult Artifacts")!
  }
  
}

extension LoresheetEntry {
  
  static var example: LoresheetEntry {
    Loresheet.example.entries[0]
  }
  
}

extension Ritual {
  
  static var example: Ritual {
    ReferenceManager.shared.ritual(named: "Incorporeal Passage")
  }
  
}
