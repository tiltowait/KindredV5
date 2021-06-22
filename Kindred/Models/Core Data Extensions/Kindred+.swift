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
  
}
