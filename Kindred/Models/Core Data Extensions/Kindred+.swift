//
//  Kindred+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

extension Kindred {
  
  /// The character's name.
  var name: String {
    get { zName ?? "" }
    set { zName = newValue }
  }
  
  /// The character's concept.
  var concept: String {
    get { zConcept ?? "" }
    set { zConcept = newValue }
  }
  
  /// The chronicle the character is in.
  var chronicle: String {
    get { zChronicle ?? "" }
    set { zConcept = newValue }
  }
  
  /// The character's long-term ambition.
  var ambition: String {
    get { zAmbition ?? "" }
    set { zAmbition = newValue }
  }
  
  /// The character's short-term desire.
  var desire: String {
    get { zDesire ?? "" }
    set { zDesire = newValue }
  }
  
  /// The character's sire.
  var sire: String {
    get { zSire ?? "" }
    set { zSire = newValue }
  }
  
  /// The character's title, such as "neonate", "ancilla", etc.
  var title: String {
    get { zTitle ?? "" }
    set { zTitle = newValue }
  }
  
  /// The character's date of birth.
  var birthDate: Date {
    get { zBirthDate ?? Date() }
    set { zBirthDate = newValue }
  }
  
  /// The date on which the character was embraced.
  var embraceDate: Date {
    get { zEmbraceDate ?? Date() }
    set { zEmbraceDate = newValue }
  }
  
  /// The character's height.
  var height: String {
    get { zHeight ?? "" }
    set { zHeight = newValue }
  }
  
  /// The character's weight.
  var weight: String {
    get { zWeight ?? "" }
    set { zWeight = newValue }
  }
  
  var allImageObjects: [KindredImage] {
    let images = images?.allObjects as? [KindredImage] ?? []
    return images.sorted()
  }
  var fullSizeImageData: [Data] {
    let images = allImageObjects
    return images.sorted().compactMap { $0.image }
  }
  
  var thumbnailImageData: [Data] {
    let images = allImageObjects
    return images.sorted().compactMap { $0.thumb }
  }
  
}

extension Kindred {
  
  /// An example Kindred used for testing purposes.
  static var example: Kindred {
    let kindred = Kindred(context: DataController.preview.container.viewContext)
    kindred.name = "Nadea Theron"
    kindred.concept = "Bahari ER Surgeon"
    kindred.ambition = "Attain mastery over Oblivion"
    kindred.desire = "Induct her ghoul into the faith"
    kindred.chronicle = "Cape Town by Night"
    kindred.weight = "115"
    kindred.height = "5'6\""
    kindred.generation = 12
    
    // Make birthdate and embrace date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    kindred.birthDate = dateFormatter.date(from: "1982/03/17")!
    kindred.embraceDate = dateFormatter.date(from: "2009/06/21")!
    kindred.sire = "Vivette de Klerk"
    
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
    
    return kindred
  }
  
}
