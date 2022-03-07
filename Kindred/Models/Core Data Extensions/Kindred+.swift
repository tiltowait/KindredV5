//
//  Kindred+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation
import CoreData

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
  
  var temporaryWillpower: Int {
    willpowerString.count { $0 == "." }
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
  
  var humanityString: String {
    get { zHumanityString ?? "ooooooo..." }
    set { zHumanityString = newValue }
  }
  
  var humanity: Int16 {
    get { Int16(humanityString.count { $0 == "o" }) }
    set {
      let filled = String(repeating: "o", count: Int(newValue))
      let empty = String(repeating: ".", count: Int(10 - newValue))
      zHumanityString = filled + empty
    }
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
  
  // MARK: Images
  
  /// The image containers, sorted by date they were added.
  var allImageObjects: [KindredImage] {
    let images = images as? Set<KindredImage>
    return images?.sorted() ?? []
  }
  
  /// The full-sized image data, sorted by creation date.
  var fullsizeImageURLs: [URL] {
    let images = allImageObjects
    return images.sorted().compactMap { $0.imageURL }
  }
  
  /// The thumbnail image data, sorted by creation date.
  var thumbnailImageURLs: [URL] {
    let images = allImageObjects
    return images.sorted().compactMap { $0.thumbnailURL }
  }
  
  // MARK: - Reference Items
  
  var predatorType: PredatorType? {
    nil
  }
  
  var clan: Clan? {
    get {
      if let ref = self.zClan?.refID {
        return ReferenceManager.shared.clan(id: ref)
      }
      return nil
    }
    set {
      if let clan = newValue {
        let container = self.zClan ?? ClanContainer(context: self.managedObjectContext!)
        container.refID = clan.id
        self.zClan = container
      } else {
        self.zClan = nil
      }
    }
  }
  
  /// The powers known by the character, sorted.
  var knownPowers: [Power] {
    let powers = self.powers as? Set<PowerContainer>
    return powers?.compactMap {
      ReferenceManager.shared.power(id: $0.refID)
    }.sorted() ?? []
  }
  
  /// The disciplines known by the character, sorted alphabetically.
  var knownDisciplines: [Discipline] {
    let disciplines = knownPowers.map(\.discipline)
    return Set(disciplines).sorted()
  }
  
  /// All rituals known by the character.
  var knownRituals: [Ritual] {
    let rituals = self.rituals as? Set<RitualContainer>
    return rituals?.compactMap {
      ReferenceManager.shared.ritual(id: $0.refID)
    }.sorted() ?? []
  }
  
  /// A list of ritual schools the character has available to them..
  var availableRitualSchools: [Ritual.Flavor] {
    var schools: [Ritual.Flavor] = []
    let disciplines = self.knownDisciplines
    
    if (disciplines.contains { $0.name == "Blood Sorcery" }) {
      schools.append(.ritual)
    }
    
    if (disciplines.contains { $0.name == "Oblivion" }) {
      schools.append(.ceremony)
    }
    
    if (disciplines.contains { $0.name == "Thin-Blood Alchemy" }) {
      schools.append(.formula)
    }
    
    return schools
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
    knownPowers.count { $0.discipline == discipline }
  }
  
  func addPower(_ power: Power) {
    let container = PowerContainer(context: self.managedObjectContext!)
    container.refID = power.id
    self.addToPowers(container)
  }
  
  func removePower(_ power: Power) {
    let powers = self.powers as? Set<PowerContainer>
    if let container = powers?.first(where: { $0.refID == power.id }) {
      self.removeFromPowers(container)
    }
  }
  
  func addRitual(_ ritual: Ritual) {
    let container = RitualContainer(context: self.managedObjectContext!)
    container.refID = ritual.id
    self.addToRituals(container)
  }
  
  func removeRitual(_ ritual: Ritual) {
    let rituals = self.rituals as? Set<RitualContainer>
    if let container = rituals?.first(where: { $0.refID == ritual.id }) {
      self.removeFromRituals(container)
    }
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
    let entries = self.loresheets as? Set<LoresheetContainer>
    return (entries?.compactMap {
      ReferenceManager.shared.loresheetEntry(id: $0.refID)
    } ?? [])
      .sorted()
  }
  
  /// Fetch all loresheet entries for a particular loresheet that the Kindred prosseses.
  /// - Parameter loresheet: The loresheet in question.
  /// - Returns: All loresheet entries for the loresheet that the Kindred possesses.
  func entries(for loresheet: Loresheet) -> [LoresheetEntry] {
    self.loresheetEntries.filter { $0.parent == loresheet }.sorted()
  }
  
  /// All the loresheets for which the character has at least one entry.
  var knownLoresheets: [Loresheet] {
    let loresheets = self.loresheetEntries.map(\.parent)
    return Set(loresheets).sorted()
  }
  
  func addLoresheetEntry(_ entry: LoresheetEntry) {
    guard let context = self.managedObjectContext else { fatalError("Can't get managed object context.") }
    let container = LoresheetContainer(context: context)
    container.refID = entry.id
    self.addToLoresheets(container)
  }
  
}
