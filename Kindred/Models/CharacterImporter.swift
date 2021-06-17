//
//  CharacterImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

/// A caseless enum that does the actual legwork of creating a new character from a PDF.
enum CharacterImporter {
  
  /// Import a character from a PDF.
  /// - Parameters:
  ///   - pdf: The PDF from which to import the character.
  ///   - dataController: The data controller responsible for saving the character.
  @discardableResult
  static func importCharacter(pdf: CharacterPDF, dataController: DataController) -> Kindred {
    let kindred = Kindred(context: dataController.container.viewContext)
    
    // Set basic traits
    kindred.name = pdf.information(for: .characterName)
    kindred.concept = pdf.information(for: .concept)
    kindred.chronicle = pdf.information(for: .chronicle)
    kindred.ambition = pdf.information(for: .ambition)
    kindred.desire = pdf.information(for: .desire)
    kindred.generation = Int16(pdf.information(for: .generation)) ?? 13
    kindred.sire = pdf.information(for: .sire)
    kindred.title = pdf.information(for: .title)
    
    // Set the attributes
    kindred.strength = pdf.rating(for: .strength)
    kindred.dexterity = pdf.rating(for: .dexterity)
    kindred.stamina = pdf.rating(for: .stamina)
    kindred.charisma = pdf.rating(for: .charisma)
    kindred.manipulation = pdf.rating(for: .manipulation)
    kindred.composure = pdf.rating(for: .composure)
    kindred.wits = pdf.rating(for: .wits)
    kindred.intelligence = pdf.rating(for: .intelligence)
    kindred.resolve = pdf.rating(for: .resolve)
    
    // Set the skills
    kindred.athletics = pdf.rating(for: .athletics)
    kindred.brawl = pdf.rating(for: .brawl)
    kindred.craft = pdf.rating(for: .craft)
    kindred.drive = pdf.rating(for: .drive)
    kindred.firearms = pdf.rating(for: .firearms)
    kindred.larceny = pdf.rating(for: .larceny)
    kindred.melee = pdf.rating(for: .melee)
    kindred.stealth = pdf.rating(for: .stealth)
    kindred.survival = pdf.rating(for: .survival)
    kindred.animalKen = pdf.rating(for: .animalKen)
    kindred.etiquette = pdf.rating(for: .etiquette)
    kindred.insight = pdf.rating(for: .insight)
    kindred.intimidation = pdf.rating(for: .intimidation)
    kindred.leadership = pdf.rating(for: .leadership)
    kindred.performance = pdf.rating(for: .performance)
    kindred.persuasion = pdf.rating(for: .persuasion)
    kindred.streetwise = pdf.rating(for: .streetwise)
    kindred.subterfuge = pdf.rating(for: .subterfuge)
    kindred.academics = pdf.rating(for: .academics)
    kindred.awareness = pdf.rating(for: .awareness)
    kindred.finance = pdf.rating(for: .finance)
    kindred.investigation = pdf.rating(for: .investigation)
    kindred.medicine = pdf.rating(for: .medicine)
    kindred.occult = pdf.rating(for: .occult)
    kindred.politics = pdf.rating(for: .politics)
    kindred.science = pdf.rating(for: .science)
    kindred.technology = pdf.rating(for: .technology)
    
    // Set the derived stats
    kindred.health = pdf.health
    kindred.willpower = pdf.willpower
    kindred.humanity = pdf.humanity
    kindred.hunger = pdf.hunger
    kindred.bloodPotency = pdf.bloodPotency
    
    return kindred
  }
  
}