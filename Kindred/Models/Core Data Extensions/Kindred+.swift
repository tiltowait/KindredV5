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
