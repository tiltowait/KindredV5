//
//  CharacterImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import CoreData

/// A caseless enum that does the actual legwork of creating a new character from a PDF.
enum CharacterImporter {
  
  /// Date format strings for attempting to get the character's birth- and embrace dates.
  static let dateFormatStrings: [String] = {
    [
      "y", // year only, no padding
      "M/y", // month and year, / delimeter, no padding on either
      "M/d/y", // month, day, year, no padding on any
      "MM/dd/yyyy", // month, day, year, padding on all
      "MM/dd/yy" // month, day, year, with padding except for 2-digit year
    ]
  }()
  
  /// Import a character from a PDF.
  /// - Parameters:
  ///   - pdf: The PDF from which to import the character.
  ///   - dataController: The data controller responsible for saving the character.
  @discardableResult
  static func importCharacter(pdf: CharacterPDF, context: NSManagedObjectContext) -> Kindred {
    let kindred = Kindred(context: context)
    
    // Set basic traits
    kindred.name = pdf.information(for: .characterName)
    kindred.concept = pdf.information(for: .concept)
    kindred.chronicle = pdf.information(for: .chronicle)
    kindred.ambition = pdf.information(for: .ambition)
    kindred.desire = pdf.information(for: .desire)
    kindred.generation = Int16(pdf.information(for: .generation)) ?? 13
    kindred.sire = pdf.information(for: .sire)
    kindred.title = pdf.information(for: .title)
    
    // Figure out its clan
    if let clan = Clan.fetchObject(named: pdf.information(for: .clan), in: context) {
      kindred.clan = clan
    }
    
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
    
    kindred.appearance = pdf.appearance
    kindred.distinguishingFeatures = pdf.distinguishingFeatures
    kindred.history = pdf.history
    kindred.possessions = pdf.possessions
    kindred.notes = pdf.notes
    
    Self.fetchDisciplines(context: context, kindred: kindred, pdf: pdf)
    Self.fetchAdvantages(context: context, kindred: kindred, pdf: pdf)
    Self.fetchHavenRating(context: context, kindred: kindred, pdf: pdf)
    
    // Birthdate and embrace date
    if let birthdateString = pdf.birthdateString {
      kindred.birthdate = Self.dateFromString(birthdateString)
    }
    if let embraceDateString = pdf.embraceDateString {
      kindred.embraceDate = Self.dateFromString(embraceDateString)
    }
    
    return kindred
  }
  
  /// Attempt to import disciplines.
  ///
  /// This function will not work if the disciplines and powers are misspelled.
  /// - Parameters:
  ///   - context: The context in which the data lives.
  ///   - kindred: The character to add the disciplines to.
  ///   - pdf: The PDF from which to import.
  private static func fetchDisciplines(context: NSManagedObjectContext, kindred: Kindred, pdf: CharacterPDF) {
    let allDisciplines = try? context.fetch(Discipline.fetchRequest()) as [Discipline]
    let allPowers = try? context.fetch(Power.fetchRequest()) as [Power]
    
    for (key, fields) in pdf.disciplineFields {
      let disciplineName = pdf.value(for: key) ?? ""
      
      if let discipline = (allDisciplines?.first { disciplineName.contains($0.name) }) {
        for field in fields {
          let powerName = pdf.value(for: field) ?? ""
          
          if let power = (allPowers?.first { powerName.contains($0.name) }) {
            if power.discipline == discipline {
              kindred.addToPowers(power)
            }
          }
        }
      }
    }
  }
  
  /// Attempt to import advantages (merits, flaws, and backgrounds).
  /// - Parameters:
  ///   - context: The context in which the data lives.
  ///   - kindred: The character to apply the advantages to.
  ///   - pdf: The PDF from which to import.
  private static func fetchAdvantages(context: NSManagedObjectContext, kindred: Kindred, pdf: CharacterPDF) {
    let advantages = pdf.allAdvantages
    
    for (advantage, rating) in advantages {
      // On the official PDF, some advantages are given a compound name, such as "Looks, Stunning".
      // We want to take only the specific advantage option name.
      let advantage = advantage.components(separatedBy: ", ").last!
      
      if let advantageOption = AdvantageOption.fetchObject(named: advantage, in: context) {
        let container = AdvantageContainer(context: context)
        container.zOption = advantageOption
        container.currentRating = advantageOption.isFlaw ? -rating : rating
        
        kindred.addToAdvantages(container)
      } else if let loresheetEntry = LoresheetEntry.fetchObject(named: advantage, in: context) {
        kindred.addToLoresheets(loresheetEntry)
      }
    }
  }
  
  /// Import the haven rating.
  ///
  /// Haven is a special section of the PDF that must be handled differently than other advantages.
  /// Importantly, this function *only* imports the rating (or No Haven); other haven merits are handled
  /// by `fetchAdvantages()`.
  /// - Parameters:
  ///   - context: The context in which the data lives.
  ///   - kindred: The character to grant haven.
  ///   - pdf: The PDF from which to import.
  private static func fetchHavenRating(context: NSManagedObjectContext, kindred: Kindred, pdf: CharacterPDF) {
    let havenRating = pdf.havenRating
    
    if havenRating > 0 {
      guard let haven = AdvantageOption.fetchObject(named: "Haven", in: context) else { return }
      
      let container = AdvantageContainer(context: context)
      container.option = haven
      container.currentRating = havenRating
      
      kindred.addToAdvantages(container)
      
    } else if pdf.noHaven {
      guard let noHaven = AdvantageOption.fetchObject(named: "No Haven", in: context) else { return }
      
      let container = AdvantageContainer(context: context)
      container.option = noHaven
      container.currentRating = -1
      
      kindred.addToAdvantages(container)
    }
  }
  
  /// Attempt to fetch a date from a string.
  /// - Parameter dateString: The date string to match.
  /// - Returns: The matched date, or nil.
  private static func dateFromString(_ dateString: String) -> Date? {
    // This is technically a fairly expensive operation, but it is only done twice per import.
    for formatString in CharacterImporter.dateFormatStrings {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = formatString
      
      if let date = dateFormatter.date(from: dateString) {
        return date
      }
    }
    return nil
  }

  
}
