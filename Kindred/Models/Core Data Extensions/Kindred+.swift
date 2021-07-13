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
    set { zChronicle = newValue }
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
  
  var healthString: String {
    get { zHealthString ?? String(repeating: ".", count: Int(self.health)) }
    set { zHealthString = newValue }
  }
  
  var willpowerString: String {
    get { zWillpowerString ?? String(repeating: ".", count: Int(self.willpower)) }
    set { zWillpowerString = newValue }
  }
  
  // MARK: - Morality
  
  var chronicleTenets: String {
    get { zChronicleTenets ?? "" }
    set { zChronicleTenets = newValue }
  }
  
  var convictions: String {
    get { zConvictions ?? "" }
    set { zConvictions = newValue }
  }
  
  var touchstones: String {
    get { zTouchstones ?? "" }
    set { zTouchstones = newValue }
  }
  
  // MARK: - Biographical Data
  
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
  
  var appearance: String {
    get { zAppearance ?? "" }
    set { zAppearance = newValue }
  }
  
  var distinguishingFeatures: String {
    get { zDistinguishingFeatures ?? "" }
    set { zDistinguishingFeatures = newValue }
  }
  
  var history: String {
    get { zHistory ?? "" }
    set { zHistory = newValue }
  }
  
  var possessions: String {
    get { zPossessions ?? "" }
    set { zPossessions = newValue }
  }
  
  var notes: String {
    get { zNotes ?? "" }
    set { zNotes = newValue }
  }
  
  // MARK: - Referenced Data
  
  /// The image containers, sorted by date they were added.
  var allImageObjects: [KindredImage] {
    let images = images as? Set<KindredImage>
    return images?.sorted() ?? []
  }
  
  /// The full-sized image data, sorted by creation date.
  var fullSizeImageData: [Data] {
    let images = allImageObjects
    return images.sorted().compactMap { $0.image }
  }
  
  /// The thumbnail image data, sorted by creation date.
  var thumbnailImageData: [Data] {
    let images = allImageObjects
    return images.sorted().compactMap { $0.thumb }
  }
  
  /// The powers known by the character, sorted.
  var knownPowers: [Power] {
    let powers = self.powers as? Set<Power>
    return powers?.sorted() ?? []
  }
  
  /// The disciplines known by the character, sorted alphabetically.
  var knownDisciplines: [Discipline] {
    let disciplines = knownPowers.compactMap { $0.discipline }
    let set = Set(disciplines)
    return set.sorted()
  }
  
  /// All the character's advantage containers, sorted.
  var advantageContainers: [AdvantageContainer] {
    let containers = advantages as? Set<AdvantageContainer>
    return containers?.sorted() ?? []
  }
  
  /// Get the Kindred's level in a given Discipline.
  /// - Parameter discipline: The Discipline in question.
  /// - Returns: The level in that Discipline.
  func level(of discipline: Discipline) -> Int {
    knownPowers.filter { $0.discipline == discipline }.count
  }
  
  var allSpecialties: [Specialty] {
    specialties?.allObjects as? [Specialty] ?? []
  }
  
  func specialties(for skill: String) -> [String]? {
    let allSpecialties = specialties as? Set<Specialty>
    let skillSpecialties = allSpecialties?.first { $0.skill == skill }
    return skillSpecialties?.specialties
  }
  
}

// MARK: - Advantage Stuff

extension Kindred {
  /// A container type for grouping AdvantageContainers with their parent Advantage
  class CoalescedAdvantage: Identifiable, Comparable {
    
    var id: ObjectIdentifier { advantage.id }
    
    let advantage: Advantage
    var containers: [AdvantageContainer] = []
    
    init(advantage: Advantage) {
      self.advantage = advantage
    }
    
    init(container: AdvantageContainer) {
      self.advantage = container.advantage
      containers.append(container)
    }
    
    @discardableResult func add(container: AdvantageContainer) -> Bool {
      if container.advantage == self.advantage {
        containers.append(container)
        containers.sort()
        return true
      }
      return false
    }
    
    static func == (lhs: Kindred.CoalescedAdvantage, rhs: Kindred.CoalescedAdvantage) -> Bool {
      lhs.advantage == rhs.advantage
    }
    
    static func <(lhs: CoalescedAdvantage, rhs: CoalescedAdvantage) -> Bool {
      lhs.advantage.name < rhs.advantage.name
    }
    
  }
  
  var coalescedAdvantages: [CoalescedAdvantage] {
    var coalescedAdvantages: [CoalescedAdvantage] = []
    
    for container in advantageContainers {
      // Attempt to simply add the container to an existing coalesced
      if let coalesced = coalescedAdvantages.first(where: { $0.advantage == container.advantage }) {
        coalesced.add(container: container)
      } else {
        coalescedAdvantages.append(CoalescedAdvantage(container: container))
      }
    }
    return coalescedAdvantages.sorted()
  }
  
}

// MARK: - Loresheet Stuff

extension Kindred {
  
  /// All loresheet entries, unsorted.
  var loresheetEntries: [LoresheetEntry] {
    self.loresheets?.allObjects as? [LoresheetEntry] ?? []
  }
  
  /// Fetch all loresheet entries for a particular loresheet that the Kindred prosseses.
  /// - Parameter loresheet: The loresheet in question.
  /// - Returns: All loresheet entries for the loresheet that the Kindred possesses.
  func entries(for loresheet: Loresheet) -> [LoresheetEntry] {
    self.loresheetEntries.filter { $0.parent == loresheet }.sorted()
  }
  
  /// All the loresheets for which the character has at least one entry.
  var knownLoresheets: [Loresheet] {
    var loresheets: Set<Loresheet> = []
    for entry in self.loresheetEntries {
      loresheets.insert(entry.parent!)
    }
    return loresheets.sorted()
  }
  
}
