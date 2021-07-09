//
//  CharacterPDF.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/13/21.
//

import PDFKit

/// A class for importing V5 characters from a standard PDF. For the purposes of this app, "standard"
/// means any official PDF made by White Wolf, as well as MrGone's PDFs. PDFs from other sources
/// are unlikely to work.
class CharacterPDF {
  
  /// A singleton importer used for testing and debugging purposes. Uses a prepackaged
  /// character PDF with known values.
  static let preview = CharacterPDF(
    url: Bundle.main.url(forResource: "Nadea Theron",
                         withExtension: "pdf")!
  )!
  
  /// An enum used to obtain basic information of the character that is usually found at the
  /// top of the PDF, such as character name, generation, etc.
  enum BasicField: String, CaseIterable {
    case characterName = "name"
    case concept
    case chronicle
    case ambition
    case desire
    case predator
    case generation
    case sire
    case title
    case clan
  }
  
  /// An enum used for determining the ratings of the character's skills and attributes. We
  /// use an enum in order to avoid the risk of accidental misspellings when using raw strings.
  enum Trait: String {
    case strength
    case dexterity
    case stamina
    case charisma
    case manipulation
    case composure
    case intelligence
    case wits
    case resolve
    case athletics
    case brawl
    case craft
    case drive
    case firearms
    case larceny
    case melee
    case stealth
    case survival
    case animalKen = "Animal Ken"
    case etiquette
    case insight
    case intimidation
    case leadership
    case performance
    case persuasion
    case streetwise
    case subterfuge
    case academics
    case awareness
    case finance
    case investigation
    case medicine
    case occult
    case politics
    case science
    case technology
    
    /// The PDF capitalizes every trait, so this property gives the enum's `rawValue`, capitalized.
    var capitalized: String {
      self.rawValue.capitalized
    }
  }
  
  /// The user-provided PDF.
  let pdf: PDFDocument
  
  // MARK: - Private Variables
  
  /// A dictionary of trait names (both attributes and abilities) and the names of the
  /// associated fields in the PDF representing their dots.
  ///
  /// Due to the potential for PDF version mismatch, these fields are programmatically
  /// generated each time a PDF is imported. This is done by visually scanning the PDF
  /// for trait names and pairing them into column bookends. The initializer then iterates
  /// over each "column pairing" and finds all PDF annotations between both elements
  /// and zips them up into an array.
  private let traitFields: [String: [String]]
  
  /// A dictionary of ability names and associated specialty fields within the PDF.
  ///
  /// These fields are determined during the initialization process along with the rating fields.
  /// They contain user text and represent user-supplied specialties.
  private let specialtyFields: [String: String]
  
  /// A dictionary of "bookends" used for determining which fields belong to a given trait.
  ///
  /// The importer assumes a standard layout of three columns: physical, social, and mental,
  /// with attributes being separate from abilities and each column sorted in alphabetical
  /// order. This is the standard layout of every single official PDF White Wolf has ever
  /// produced.
  let columnBookends: [String: String?] = [
    // First column
    "Strength": "Charisma",
    "Dexterity": "Manipulation",
    "Stamina": "Composure",
    "Athletics": "Animal Ken",
    "Brawl": "Etiquette",
    "Craft": "Insight",
    "Drive": "Intimidation",
    "Firearms": "Leadership",
    "Larceny": "Performance",
    "Melee": "Persuasion",
    "Stealth": "Streetwise",
    "Survival": "Subterfuge",
    
    // Second column
    "Charisma": "Intelligence",
    "Manipulation": "Wits",
    "Composure": "Resolve",
    "Animal Ken": "Academics",
    "Etiquette": "Awareness",
    "Insight": "Finance",
    "Intimidation": "Investigation",
    "Leadership": "Medicine",
    "Performance": "Occult",
    "Persuasion": "Politics",
    "Streetwise": "Science",
    "Subterfuge": "Technology",
    
    // Third column
    "Intelligence": nil,
    "Wits": nil,
    "Resolve": nil,
    "Academics": nil,
    "Awareness": nil,
    "Finance": nil,
    "Investigation": nil,
    "Medicine": nil,
    "Occult": nil,
    "Politics": nil,
    "Science": nil,
    "Technology": nil
  ]
  
  /// The field names for disciplines and powers
  let disciplineFields: [String: [String]] = [
    "disciplineslist1": [
      "disciplines2",
      "disciplines3",
      "disciplines4",
      "disciplines5",
      "disciplines6",
    ],
    "disciplineslist4": [
      "disciplines20",
      "disciplines21",
      "disciplines22",
      "disciplines23",
      "disciplines24",
    ],
    "disciplineslist2": [
      "disciplines8",
      "disciplines9",
      "disciplines10",
      "disciplines11",
      "disciplines12",
    ],
    "disciplineslist5": [
      "disciplines26",
      "disciplines27",
      "disciplines28",
      "disciplines29",
      "disciplines30",
    ],
    "disciplineslist3": [
      "disciplines14",
      "disciplines15",
      "disciplines16",
      "disciplines17",
      "disciplines18",
    ],
    "disciplineslist6": [
      "disciplines32",
      "disciplines33",
      "disciplines34",
      "disciplines35",
      "disciplines36",
    ]
  ]
  
  /// The dot fields associated with a given discipline group.
  let disciplineDots: [String: [String]] = [
    "disciplineslist1": [
      "dot149b",
      "dot150b",
      "dot151b",
      "dot152b",
      "dot152ab"
    ],
    "disciplineslist2": [
      "dot149qb",
      "dot150qb",
      "dot151qb",
      "dot152qb",
      "dot152qab"
    ],
    "disciplineslist3": [
      "dot309b",
      "dot310b",
      "dot311b",
      "dot312b",
      "dot312ab"
    ],
    "disciplineslist4": [
      "dot229b",
      "dot230b",
      "dot231b",
      "dot232b",
      "dot232ab"
    ],
    "disciplineslist5": [
      "dot229qb",
      "dot230qb",
      "dot231qb",
      "dot232qb",
      "dot232qab"
    ],
    "disciplineslist6": [
      "dot309qb",
      "dot310qb",
      "dot311qb",
      "dot312qb",
      "dot312qab"
    ]
  ]
  
  /// Fields for the clan bane.
  let baneFields = [
    "CB1", "CB2", "CB3", "CB4", "CB5", "CB6"
  ]
  
  let backgroundFields = [
    "backgrounds1": ["dot317b", "dot318b", "dot319b", "dot320b", "dot320ab"],
    "backgrounds2": ["dot325b", "dot326b", "dot327b", "dot328b", "dot328ab"],
    "backgrounds3": ["dot333b", "dot334b", "dot335b", "dot336b", "dot336ab"],
    "backgrounds4": ["dot341b", "dot342b", "dot343b", "dot344b", "dot344ab"],
    "backgrounds5": ["dot349b", "dot350b", "dot351b", "dot352b", "dot352ab"],
    "backgrounds6": ["dot357b", "dot358b", "dot359b", "dot360b", "dot360ab"],
    "backgrounds7": ["dot365b", "dot366b", "dot367b", "dot368b", "dot368ab"],
    "backgrounds8": ["dot373b", "dot374b", "dot375b", "dot376b", "dot376ab"],
    "backgrounds9": ["dot381b", "dot382b", "dot383b", "dot384b", "dot384ab"]
  ]
  
  let meritFields = [
    "merits1": ["dot389b", "dot390b", "dot391b", "dot392b", "dot392ab"],
    "merits2": ["dot397b", "dot398b", "dot399b", "dot400b", "dot400ab"],
    "merits3": ["dot405b", "dot406b", "dot407b", "dot408b", "dot408ab"],
    "merits4": ["dot541b", "dot542b", "dot543b", "dot544b", "dot544ab"],
    "merits5": ["dot549b", "dot550b", "dot551b", "dot552b", "dot552ab"],
    "merits6": ["dot557b", "dot558b", "dot559b", "dot560b", "dot560ab"],
    "merits7": ["dot557qb", "dot558qb", "dot559qb", "dot560qb", "dot560qab"]
  ]
  
  let flawFields = [
    "flaws1": ["dot566b", "dot567b", "dot568b", "dot569b", "dot569ab"],
    "flaws2": ["dot574b", "dot575b", "dot576b", "dot577b", "dot577ab"],
    "flaws3": ["dot582b", "dot583b", "dot584b", "dot585b", "dot585ab"],
    "flaws4": ["dot582qb", "dot583qb", "dot584qb", "dot585qb", "dot585qab"],
    "flaws5": ["dot590b", "dot591b", "dot592b", "dot593b", "dot593ab"],
    "flaws6": ["dot598b", "dot599b", "dot600b", "dot601b", "dot601ab"],
    "flaws7": ["dot606b", "dot607b", "dot608b", "dot609b", "dot609ab"]
  ]
  
  let noteFields = (1...13).map { "notes\($0)" }
  
  /// A dictionary of all annotations on the PDF's first page, with the annotation name as the key.
  private let allAnnotations: [String: PDFAnnotation]
  
  // MARK: - Initializers
  
  /// Create a CharacterImporter. If there is no PDF at the supplied URL, or if the URL is invalid, it will return `nil`.
  ///
  /// While attribute and ability names are hardcoded, "dot" fields are not and are automatically generated. This importer
  /// assumes a standard layout.
  /// - Parameter url: The URL of the PDF to import.
  convenience init?(url: URL) {
    guard let pdf = PDFDocument(url: url) else {
      return nil
    }
    self.init(pdf: pdf)
  }
  
  convenience init?(data: Data) {
    let pdf = PDFDocument(data: data) ?? PDFDocument()
    self.init(pdf: pdf)
  }
  
  private init?(pdf: PDFDocument) {
    self.pdf = pdf
    
    // Make sure the PDF isn't obviously the wrong format
    guard let title = pdf.documentAttributes?["Title"] as? String else { return nil }
    if title != "Vampire the Masquerade 5th Edition Character Sheet" {
      return nil
    }
    
    let page = pdf.page(at: 0)! // Only the first page has skills and attributes we care about
    let contents = page.string!
    
    // Create the quick-lookup annotations dictionary
    // We'll get the annotations from all pages, however.
    var allAnnotations: [String: PDFAnnotation] = [:]
    for pageIndex in 0..<pdf.pageCount {
      for annotation in pdf.page(at: pageIndex)!.annotations {
        if let fieldName = annotation.fieldName {
          allAnnotations[fieldName] = annotation
        }
      }
    }
    self.allAnnotations = allAnnotations
    
    // Try to programmatically generate the button lists. We do this by finding all "dot" buttons
    // between two traits.
    
    var traitFields: [String: [String]] = [:]
    var specialtyFields: [String: String] = [:]
    
    for (desiredTrait, adjacentTrait) in columnBookends {
      
      // Find the indices of the traits (as represented in the page's raw string contents
      
      guard let leadingIndex = contents.index(of: desiredTrait)?.utf16Offset(in: contents) else {
        // If the PDF doesn't contain the desired trait, it's invalid
        return nil
      }
      
      let trailingIndex: Int?
      if let adjacentTrait = adjacentTrait {
        trailingIndex = contents.index(of: adjacentTrait)?.utf16Offset(in: contents)
        
        // As before, if it doesn't contain the adjacent trait, then it's invalid
        if trailingIndex == nil {
          return nil
        }
      } else {
        // It's the last column
        trailingIndex = nil
      }
      
      // With the indices located, locate the position of both traits in page coordinates
      
      let leadingBounds = page.characterBounds(at: leadingIndex)
      
      // trailingBounds is more complex, because we might be looking at the last column
      let trailingBounds: CGRect
      
      if let trailingIndex = trailingIndex {
        // Not the last column
        trailingBounds = page.characterBounds(at: trailingIndex)
      } else {
        // This is the last column, so we need to get everything from now to the page's right gutter
        let pageBounds = page.bounds(for: .cropBox)
        
        trailingBounds = CGRect(x: pageBounds.maxX,
                                y: leadingBounds.minY,
                                width: 0,
                                height: leadingBounds.height)
      }
      
      let gapBounds = CGRect(x: leadingBounds.origin.x,
                             y: leadingBounds.origin.y,
                             width: trailingBounds.origin.x - leadingBounds.origin.x,
                             height: leadingBounds.height)
      
      // Scan horizontally across the page starting from the left column and ending at the right.
      // This will pick up all annotation objects between the two columns.
      
      var fields: [String] = []
      let start = Int(gapBounds.minX)
      let end = Int(gapBounds.maxX)
      
      for x in start...end {
        let point = CGPoint(x: CGFloat(x), y: gapBounds.midY)
        
        // Capture the field at the current point, if any
        if let field = page.annotation(at: point)?.fieldName {
          // Abilities have an additional field for specialties, which we shuffle off to the
          // appropriate dictionary
          if field.contains("abilities") {
            specialtyFields[desiredTrait] = field
          } else if !fields.contains(field) { // Make sure we don't add the field more than once
            fields.append(field)
          }
        }
      }
      traitFields[desiredTrait] = fields
    }
    self.traitFields = traitFields
    self.specialtyFields = specialtyFields
  }
  
  // MARK: - Public Accessors
  
  /// Retrieve the character's rating in a given attribute or ability. If the `trait` is invalid, it will return 0.
  /// - Parameter trait: The trait to look up.
  /// - Returns: The character's rating in that trait.
  func rating(for trait: Trait) -> Int16 {
    let trait = trait.capitalized
    let fields = traitFields[trait] ?? []
    return countSelected(for: fields)
  }
  
  /// Retrieve the character's specialty/specialties for a given ability.
  /// - Parameter ability: The ability to look up.
  /// - Returns: The ability's specialty/specialties, or nil if the ability is invalid or does not have a specialty.
  func specialty(for ability: String) -> String? {
    if let field = specialtyFields[ability] {
      if let specialty = value(for: field) {
        if !specialty.isEmpty {
          return specialty
        }
      }
    }
    return nil
  }
  
  /// Retrieve basic character information, such as name, sire, generation, etc.
  /// - Parameter trait: The trait to look up.
  /// - Returns: The requested information, which may be an empty string.
  func information(for trait: BasicField) -> String {
    value(for: trait.rawValue) ?? ""
  }
  
  /// Returns a representation of the document as an NSData object.
  func dataRepresentation() -> Data? {
    pdf.dataRepresentation()
  }
  
  // MARK: - Derived Traits
  
  /// The character's maximum Health rating.
  var health: Int16 {
    let fields = (1...15).map { "check\($0)" }
    return 15 - countSelected(for: fields)
  }
  
  /// The character's maximum Willpower rating.
  var willpower: Int16 {
    let fields = (16...30).map { "check\($0)" }
    return 15 - countSelected(for: fields)
  }
  
  /// The character's Humanity rating.
  var humanity: Int16 {
    let fields = (31...40).map { "check\($0)" }
    return countSelected(for: fields)
  }
  
  /// The character's current Hunger level.
  var hunger: Int16 {
    let fields = (41...45).map { "check\($0)" }
    return countSelected(for: fields)
  }
  
  /// The character's Blood Potency.
  var bloodPotency: Int16 {
    let fields = (1...10).map { "hdot\($0)" }
    return countSelected(for: fields)
  }
  
  /// All advantages with their associated ratings.
  var advantages: [String: Int16] {
    var advantages: [String: Int16] = [:]

    let advantageFields = backgroundFields.merging(with: meritFields, flawFields)
    
    for (advantageLabel, dotFields) in advantageFields {
      if let advantage = allAnnotations[advantageLabel]?.widgetStringValue {
        let rating = countSelected(for: dotFields)
        advantages[advantage] = rating
      }
    }
    return advantages
  }
  
  var birthdateString: String? {
    allAnnotations["bio3"]?.widgetStringValue
  }
  
  var embraceDateString: String? {
    allAnnotations["bio4"]?.widgetStringValue
  }
  
  /// The contents of the PDF's "notes" section, with line breaks.
  var notes: String {
    var noteLines: [String] = []
    for noteField in noteFields {
      if let line = allAnnotations[noteField]?.widgetStringValue {
        noteLines.append(line)
      }
    }
    return noteLines.joined(separator: "\n")
  }
  
  // MARK: - Private Methods
  
  /// Private function for counting the number of "Yes" fields in a list of field names.
  ///
  /// This function is a helper function used for determining ratings for derived and concrete traits.
  /// - Parameter fields: The names of the fields to query
  /// - Returns: The count of fields that have "Yes" as the value
  private func countSelected(for fields: [String]) -> Int16 {
    var dots: Int16 = 0
    for field in fields {
      if value(for: field) == "Yes" {
        dots += 1
      }
    }
    return dots
  }
  
  /// Retrieve the value of a given field.
  ///
  /// This method is private, because the user should not have to worry about the underlying structure
  /// of the PDF.
  /// - Parameter field: The name of the field to look up.
  /// - Returns: The value stored in that field. If the field is empty or doesn't exist, it returns `nil`.
  func value(for field: String) -> String? {
    if let annotation = allAnnotations[field] {
      if let widgetStringValue = annotation.widgetStringValue {
        if !widgetStringValue.isEmpty {
          return widgetStringValue
        }
      }
    }
    return nil
  }
  
}
  
// MARK: - Temporary Development/Testing Variables

extension CharacterPDF: CustomStringConvertible {
  
  /// Every trait with rating, each on its own line.
  var traits: String {
    var traits: [String] = []
    
    for (trait, fields) in self.traitFields {
      let dots = countSelected(for: fields)
      traits.append("\(trait): \(dots)")
    }
    return traits.sorted().joined(separator: "\n")
  }
  
  /// The names of every single annotation field name on the first page, each on its own line.
  var firstPageFields: String {
    let page = pdf.page(at: 0)!
    var fieldNames = ""
    
    for annotation in page.annotations {
      if let fieldName = annotation.fieldName {
        fieldNames += "\(fieldName)"
        if let widgetString = annotation.widgetStringValue {
          fieldNames += " \"\(widgetString)\""
        }
        fieldNames += "\n"
      }
    }
    return fieldNames
  }
  
  /// A string containing all basic information about the character.
  var description: String {
    let info = BasicField.allCases.map { trait in
      "\(trait.rawValue): \(information(for: trait))"
    }
    return info.joined(separator: "\n")
  }
  
}

// MARK: - PDF Creation

extension CharacterPDF {
  
  /// The string value of enabled checkboxes.
  private var enabled: String { "Yes" }
  
  /// Create a character sheet for a given character.
  convenience init(character: Kindred) {
    guard let url = Bundle.main.url(forResource: "Blank Character Sheet", withExtension: "pdf") else {
      fatalError("Unable to locate blank character sheet.")
    }
    self.init(url: url)!
    
    self.setBasicFields(character: character)
    self.setTraits(character: character)
    
    self.setHealth(to: character.health)
    self.setWillpower(to: character.willpower)
    self.setHumanity(to: character.humanity)
    self.setHunger(to: character.hunger)
    self.setBloodPotency(to: character.bloodPotency)
    
    // TODO: Do something with the return values.
    
    _ = self.setDisciplines(character: character)
    
    self.setBaneDescription(to: character.clan?.bane ?? "")
    self.setBloodPotencyFields(potency: character.bloodPotency)
    
    _ = self.setBackgrounds(character: character)
    _ = self.setMerits(character: character)
    _ = self.setFlaws(character: character)
    
    // Set birth- and death-dates
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    
    if let birthdate = character.birthdate {
      allAnnotations["bio3"]?.widgetStringValue = dateFormatter.string(from: birthdate)
    }
    if let deathdate = character.embraceDate {
      allAnnotations["bio4"]?.widgetStringValue = dateFormatter.string(from: deathdate)
    }
    
    self.setNotes(character.notes)
  }
  
  // MARK: - Setters
  
  /// Fill in the details for a basic field, such as name, concept, sire, etc.
  /// - Parameters:
  ///   - field: The field to fill.
  ///   - newValue: The field's new contents.
  func setField(_ field: BasicField, to newValue: String) {
    if let annotation = allAnnotations[field.rawValue] {
      annotation.widgetStringValue = newValue
    }
  }
  
  /// Fill in the dots for a trait.
  /// - Parameters:
  ///   - trait: The trait to fill.
  ///   - newValue: The number of dots to fill.
  func setTrait(_ trait: Trait, to newValue: Int16) {
    let fields = traitFields[trait.capitalized]!
    
    for index in 0..<Int(newValue) {
      let field = fields[index]
      allAnnotations[field]?.widgetStringValue = enabled
    }
  }
  
  /// Fill the health boxes on the first page.
  ///
  /// The boxes are filled in from the right.
  func setHealth(to health: Int16) {
    let fields = (1...15).map { "check\($0)" }
    
    for field in fields.dropFirst(Int(health)) {
      allAnnotations[field]?.widgetStringValue = enabled
    }
  }
  
  /// Fill the willpower boxes on the first page.
  ///
  /// The boxes are filled in from the right.
  func setWillpower(to willpower: Int16) {
    let fields = (16...30).map { "check\($0)" }
    
    for field in fields.dropFirst(Int(willpower)) {
      allAnnotations[field]?.widgetStringValue = enabled
    }
  }
  
  /// Fill the humanity dots on the first page.
  func setHumanity(to humanity: Int16) {
    let fields = (31...40).map { "check\($0)" }
    let drop = 10 - Int(humanity)
    
    for field in fields.dropLast(drop) {
      allAnnotations[field]?.widgetStringValue = enabled
    }
  }
  
  /// Fill the hunger dots on the first page.
  func setHunger(to hunger: Int16) {
    let fields = (41...45).map { "check\($0)" }
    let drop = 5 - Int(hunger)
    
    for field in fields.dropLast(drop) {
      allAnnotations[field]?.widgetStringValue = enabled
    }
  }
  
  /// Fill the blood potency dots on the first page.
  func setBloodPotency(to bloodPotency: Int16) {
    let fields = (1...10).map { "hdot\($0)" }
    let drop = 10 - Int(bloodPotency)
    
    for field in fields.dropLast(drop) {
      allAnnotations[field]?.widgetStringValue = enabled
    }
  }
  
  /// Fill out the disciplines section on the first page.
  /// - Returns: True if there was enough space to fit all the disciplines.
  func setDisciplines(character: Kindred) -> Bool {
    let disciplines = character.knownDisciplines
    let powers = character.knownPowers
    
    var couldFitAll = true
    
    for (index, discipline) in disciplines.enumerated() {
      let labelField = "disciplineslist\(index + 1)"
      if let fields = disciplineFields[labelField] {
        allAnnotations[labelField]?.widgetFieldType = .text
        allAnnotations[labelField]?.widgetStringValue = discipline.name
        
        // Set the powers
        let powers = powers.filter { $0.discipline == discipline }
        for (index, power) in powers.enumerated() {
          if index < fields.count {
            let field = fields[index]
            allAnnotations[field]?.widgetStringValue = power.name
          } else {
            couldFitAll = false
          }
        }
        
        // Set the dots
        let dots = powers.count
        let dotFields = disciplineDots[labelField]!.dropLast(5 - dots)
        for field in dotFields {
          allAnnotations[field]?.widgetStringValue = enabled
        }
      } else {
        couldFitAll = false
      }
    }
    return couldFitAll
  }
  
  /// Fill out the character's bane description on the front page.
  ///
  /// The details are split across the available lines as evenly as possible.
  /// - Parameter bane: The bane description.
  func setBaneDescription(to bane: String) {
    let lines = bane.split(lines: baneFields.count).components(separatedBy: .newlines)
    for (line, field) in zip(lines, baneFields) {
      allAnnotations[field]?.widgetStringValue = line
    }
  }
  
  /// Fill out the blood potency fields on the first page.
  ///
  /// This method relies on the BloodPotency struct.
  /// - Parameter potency: The character's blood potency.
  func setBloodPotencyFields(potency: Int16) {
    let bloodPotency = BloodPotency(potency)
    
    allAnnotations["BPstat1"]?.widgetStringValue = "\(bloodPotency.surgeString)"
    allAnnotations["BPstat2"]?.widgetStringValue = "\(bloodPotency.mendString)"
    allAnnotations["BPstat3"]?.widgetStringValue = "\(bloodPotency.powerBonusString)"
    allAnnotations["BPstat4"]?.widgetStringValue = "\(bloodPotency.rouseRerollString)"
    allAnnotations["BPstat5"]?.widgetStringValue = bloodPotency.penalty
    allAnnotations["BPstat6"]?.widgetStringValue = String(bloodPotency.baneSeverity)
  }
  
  /// Fill out the backgrounds section on the second page of the character sheet.
  /// - Returns: True if there was enough space to mark all the character's backgrounds.
  func setBackgrounds(character: Kindred) -> Bool {
    let backgrounds = character.advantageContainers.filter { $0.isBackground }
    var backgroundNames = backgrounds.map { $0.fullName }
    var ratings = backgrounds.map { $0.currentRating }
    
    // Loresheets also go under backgrounds, so we'll add them here
    let loresheets = character.loresheetEntries
    let loresheetNames = loresheets.map { $0.fullName }
    let loresheetRatings = loresheets.map { $0.level }
    
    backgroundNames.append(contentsOf: loresheetNames)
    ratings.append(contentsOf: loresheetRatings)
    
    let ratedBackgrounds = Dictionary(uniqueKeysWithValues: zip(backgroundNames, ratings))
    
    return setFields(backgroundFields, to: ratedBackgrounds)
  }
  
  /// Fill out the merits section on the second page of the character sheet.
  /// - Returns: True if there was enough space to mark all the character's merits.
  func setMerits(character: Kindred) -> Bool {
    let merits = character.advantageContainers.filter { $0.isMerit }
    let meritNames = merits.map { $0.fullName }
    let ratings = merits.map { $0.currentRating }
    
    let ratedMerits = Dictionary(uniqueKeysWithValues: zip(meritNames, ratings))
    
    return setFields(meritFields, to: ratedMerits)
  }
  
  /// Fill out the flaws section on the second page of the character sheet.
  /// - Returns: True if there was enough space to mark all the character's flaws.
  func setFlaws(character: Kindred) -> Bool {
    let flaws = character.advantageContainers.filter { $0.isFlaw }
    let flawNames = flaws.map { $0.fullName }
    let ratings = flaws.map { $0.currentRating }
    
    let ratedFlaws = Dictionary(uniqueKeysWithValues: zip(flawNames, ratings))
    
    return setFields(flawFields, to: ratedFlaws)
  }
  
  /// Fill out the contents of the "notes" section on the second page.
  ///
  /// The notes are divided among the lines as evenly as possible.
  func setNotes(_ text: String) {
    let idealLineLength = 20
    let words = text.components(separatedBy: .whitespacesAndNewlines).count
    
    // If the notes are longer than 260 words, then we will just split
    // evenly across all 13 lines. Otherwise, we split according to the
    // ideal line length.
    
    let numLines = words < 260 ? words / idealLineLength : words / 13
    if numLines > 0 {
      let lines = text.split(lines: numLines).components(separatedBy: .newlines)
      
      for (index, line) in lines.enumerated() {
        allAnnotations["notes\(index + 1)"]?.widgetStringValue = line
      }
    }
  }
  
  // MARK: - Private Mass Setters
  
  /// Fill out the character's basic attributes, such as name, clan, concept, etc.
  private func setBasicFields(character: Kindred) {
    self.setField(.characterName, to: character.name)
    self.setField(.concept, to: character.concept)
    self.setField(.chronicle, to: character.chronicle)
    self.setField(.ambition, to: character.ambition)
    self.setField(.desire, to: character.desire)
    self.setField(.predator, to: character.predatorType?.name ?? "")
    self.setField(.generation, to: String(character.generation))
    self.setField(.sire, to: character.sire)
    self.setField(.title, to: character.title)
    self.setField(.clan, to: character.clan?.name ?? "")
  }
  
  /// Fill out the character's skills and attributes.
  private func setTraits(character: Kindred) {
    // Attributes
    self.setTrait(.strength, to: character.strength)
    self.setTrait(.dexterity, to: character.dexterity)
    self.setTrait(.stamina, to: character.stamina)
    self.setTrait(.charisma, to: character.charisma)
    self.setTrait(.charisma, to: character.charisma)
    self.setTrait(.manipulation, to: character.manipulation)
    self.setTrait(.composure, to: character.composure)
    self.setTrait(.intelligence, to: character.intelligence)
    self.setTrait(.wits, to: character.wits)
    self.setTrait(.resolve, to: character.resolve)
    
    // Physical Skills
    self.setTrait(.athletics, to: character.athletics)
    self.setTrait(.brawl, to: character.brawl)
    self.setTrait(.craft, to: character.craft)
    self.setTrait(.drive, to: character.drive)
    self.setTrait(.firearms, to: character.firearms)
    self.setTrait(.larceny, to: character.larceny)
    self.setTrait(.melee, to: character.melee)
    self.setTrait(.stealth, to: character.stealth)
    self.setTrait(.survival, to: character.survival)

    // Mental Skills
    self.setTrait(.animalKen, to: character.animalKen)
    self.setTrait(.etiquette, to: character.etiquette)
    self.setTrait(.insight, to: character.insight)
    self.setTrait(.intimidation, to: character.intimidation)
    self.setTrait(.leadership, to: character.leadership)
    self.setTrait(.performance, to: character.performance)
    self.setTrait(.persuasion, to: character.persuasion)
    self.setTrait(.streetwise, to: character.streetwise)
    self.setTrait(.subterfuge, to: character.subterfuge)

    // Social Skills
    self.setTrait(.academics, to: character.academics)
    self.setTrait(.awareness, to: character.awareness)
    self.setTrait(.finance, to: character.finance)
    self.setTrait(.investigation, to: character.investigation)
    self.setTrait(.medicine, to: character.medicine)
    self.setTrait(.occult, to: character.occult)
    self.setTrait(.politics, to: character.politics)
    self.setTrait(.science, to: character.science)
    self.setTrait(.technology, to: character.technology)
  }
  
  /// Fill out a number of fields to given and fill in the dot ratings.
  ///
  /// This is used for setting flaws, merits, backgrounds, and haven details on the second page.
  ///
  /// Each argument should contain the same number of elements, or the app may crash.
  /// - Parameters:
  ///   - fields: The names of the labels and associated dot fields for storing the names and ratings of the advantages.
  ///   - ratings: The name and associated rating for each advantage.
  /// - Returns: True if there was enough space on the sheet to fit all the given advantages.
  private func setFields(_ fields: [String: [String]], to ratings: [String: Int16]) -> Bool {
    var couldFitAll = true
    let sortedFields = fields.sorted { $0.key < $1.key }
    
    for (index, (label, rating)) in ratings.enumerated() {
      if index < sortedFields.count {
        let (labelField, ratingFields) = sortedFields[index]
        
        allAnnotations[labelField]?.widgetFieldType = .text
        allAnnotations[labelField]?.widgetStringValue = label
        self.selectDots(rating, in: ratingFields)
        
      } else {
        couldFitAll = false
        break
      }
    }
    return couldFitAll
  }
  
  /// Fill out a number of dots based on a given rating.
  /// - Parameters:
  ///   - rating: The number of dots in the sequence to select.
  ///   - fields: The names of the fields to be selected.
  private func selectDots(_ rating: Int16, in fields: [String]) {
    let rating = abs(rating) // Flaws have negative ratings
    
    for (index, field) in fields.enumerated() {
      if rating > index {
        allAnnotations[field]?.widgetStringValue = enabled
      }
    }
  }
  
}
