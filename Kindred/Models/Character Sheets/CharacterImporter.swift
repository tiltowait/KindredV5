//
//  CharacterImporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import CoreData

/// A caseless enum that does the actual legwork of creating a new character from a PDF.
struct CharacterImporter {
  
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
  
  let pdf: CharacterPDF
  let context: NSManagedObjectContext
  
  var character: Kindred?
  var importErrors: [String: [String]] = [:]
  
  @discardableResult
  init(pdf: CharacterPDF, context: NSManagedObjectContext, completionHandler: @escaping (Self) -> ()) {
    self.pdf = pdf
    self.context = context
    
    importCharacter()
    
    completionHandler(self)
  }
  
  // MARK: - Import Methods
  
  /// Import a character from a PDF.
  private mutating func importCharacter() {
    let kindred = Kindred(context: context)
    
    // Convictions and chronicle tenets
    kindred.chronicleTenets = pdf.chronicleTenets.joined(separator: "\n")
    kindred.convictions = pdf.convictions.joined(separator: "\n")
    
    // Set basic traits
    kindred.name = pdf.information(for: .characterName)
    kindred.concept = pdf.information(for: .concept)
    kindred.chronicle = pdf.information(for: .chronicle)
    kindred.ambition = pdf.information(for: .ambition)
    kindred.desire = pdf.information(for: .desire)
    kindred.generation = Int16(pdf.information(for: .generation)) ?? 13
    kindred.sire = pdf.information(for: .sire)
    kindred.title = pdf.information(for: .title)
    
    self.assignSpecialties(context: context, kindred: kindred, pdf: pdf)
    
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
    
    let disciplineErrors = self.fetchDisciplines()
    importErrors = importErrors.merging(with: disciplineErrors)
    
    let advantageErrors = self.fetchAdvantages()
    importErrors["Advantages"] = advantageErrors
    
    self.fetchHavenRating()
    
    // Birthdate and embrace date
    if let birthdateString = pdf.birthdateString {
      kindred.birthdate = self.dateFromString(birthdateString)
    }
    if let embraceDateString = pdf.embraceDateString {
      kindred.embraceDate = self.dateFromString(embraceDateString)
    }
    
    self.character = kindred
  }
  
  private mutating func assignSpecialties(context: NSManagedObjectContext, kindred: Kindred, pdf: CharacterPDF) {
    let specialtyDict = pdf.specialties
    
    for (skill, specialties) in specialtyDict {
      let specialty = Specialty(context: context)
      specialty.skill = skill
      specialty.parent = kindred
      
      let specialties = specialties.components(separatedBy: ", ")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
      
      specialty.specialties = specialties
    }
  }
  
  /// Attempt to import disciplines.
  ///
  /// This function will not work if the disciplines and powers are misspelled.
  /// - Returns: The disciplines and powers that could not be found.
  private mutating func fetchDisciplines() -> [String: [String]] {
    let allDisciplines = try? context.fetch(Discipline.fetchRequest()) as [Discipline]
    let allPowers = try? context.fetch(Power.fetchRequest()) as [Power]
    
    var failedDisciplines: [String] = []
    var failedPowers: [String] = []
    
    for (key, fields) in pdf.disciplineFields {
      if let disciplineName = pdf.value(for: key) {
        
        // We aren't directly comparing the names, so we can't simply use fetchObject
        if let discipline = (allDisciplines?.first { disciplineName.lowercased().contains($0.name.lowercased()) }) {
          for field in fields {
            if let powerName = pdf.value(for: field) {
              if let power = (allPowers?.first { powerName.lowercased().contains($0.name.lowercased()) }) {
                if power.discipline == discipline {
                  character?.addToPowers(power)
                } else {
                  failedPowers.append(powerName)
                }
              } else {
                failedPowers.append(powerName)
              }
            }
          }
        } else {
          failedDisciplines.append(disciplineName)
        }
      }
    }
    
    var errors: [String: [String]] = [:]
    if !failedDisciplines.isEmpty {
      errors["Disciplines"] = failedDisciplines
    }
    if !failedPowers.isEmpty {
      errors["Powers"] = failedPowers
    }
    return errors
  }
  
  /// Attempt to import advantages (merits, flaws, and backgrounds).
  /// - Returns: The advantages that could not be found.
  private mutating func fetchAdvantages() -> [String] {
    let advantages = pdf.allAdvantages
    
    var failedAdvantages: [String] = []
    
    for (advantage, rating) in advantages {
      // On the official PDF, some advantages are given a compound name, such as "Looks, Stunning".
      // We want to take only the specific advantage option name.
      let advantage = advantage.components(separatedBy: ", ").last!
      
      if let advantageOption = AdvantageOption.fetchObject(named: advantage, in: context) {
        let container = AdvantageContainer(context: context)
        container.zOption = advantageOption
        container.currentRating = advantageOption.isFlaw ? -rating : rating
        
        character?.addToAdvantages(container)
      } else if let loresheetEntry = LoresheetEntry.fetchObject(named: advantage, in: context) {
        character?.addToLoresheets(loresheetEntry)
      } else {
        failedAdvantages.append(advantage)
      }
    }
    return failedAdvantages
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
  private mutating func fetchHavenRating() {
    let havenRating = pdf.havenRating
    
    if havenRating > 0 {
      guard let haven = AdvantageOption.fetchObject(named: "Haven", in: context) else { return }
      
      let container = AdvantageContainer(context: context)
      container.option = haven
      container.currentRating = havenRating
      
      character?.addToAdvantages(container)
      
    } else if pdf.noHaven {
      guard let noHaven = AdvantageOption.fetchObject(named: "No Haven", in: context) else { return }
      
      let container = AdvantageContainer(context: context)
      container.option = noHaven
      container.currentRating = -1
      
      character?.addToAdvantages(container)
    }
  }
  
  /// Attempt to fetch a date from a string.
  /// - Parameter dateString: The date string to match.
  /// - Returns: The matched date, or nil.
  private mutating func dateFromString(_ dateString: String) -> Date? {
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
