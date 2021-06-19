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
  
  // MARK: - Private Variables
  
  /// The user-provided PDF.
  private let pdf: PDFDocument
  
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
  
  /// A dictionary of all annotations on the PDF's first page, with the annotation name as the key.
  private let allAnnotations: [String: PDFAnnotation]
  
  // MARK: - Public Methods and Initializers
  
  /// Create a CharacterImporter. If there is no PDF at the supplied URL, or if the URL is invalid, it will return `nil`.
  ///
  /// While attribute and ability names are hardcoded, "dot" fields are not and are automatically generated. This importer
  /// assumes a standard layout.
  /// - Parameter url: The URL of the PDF to import.
  init?(url: URL) {
    guard let pdf = PDFDocument(url: url) else {
      return nil
    }
    self.pdf = pdf
    
    // Make sure the PDF isn't obviously the wrong format
    guard let title = pdf.documentAttributes?["Title"] as? String else { return nil }
    if title != "Vampire the Masquerade 5th Edition Character Sheet" {
      return nil
    }
    
    let page = pdf.page(at: 0)! // Only the first page has skills and attributes we care about
    let contents = page.string!
    
    // Create the quick-lookup annotations dictionary
    
    var allAnnotations: [String: PDFAnnotation] = [:]
    for annotation in page.annotations {
      if let fieldName = annotation.fieldName {
        allAnnotations[fieldName] = annotation
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
  
  // MARK: - Public Variables
  
  /// An alphabetized list of every attribute and ability.
  private(set) lazy var traitNames: [String] = {
    Array(traitFields.keys).sorted()
  }()
  
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
  private func value(for field: String) -> String? {
    if let annotation = allAnnotations[field] {
      if let widgetStringValue = annotation.widgetStringValue {
        if !widgetStringValue.isEmpty {
          return annotation.widgetStringValue
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
