//
//  KindredTests.swift
//  KindredTests
//
//  Created by Jared Lindsay on 5/20/21.
//

import XCTest
@testable import Kindred

class KindredTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }

  func testAttributes() {
    let traitReference = TraitReference()
    
    // Test attribute counts
    XCTAssert(traitReference.physicalAttributes.count == 3)
    XCTAssert(traitReference.socialAttributes.count == 3)
    XCTAssert(traitReference.mentalAttributes.count == 3)
    
    // Test existence of three random attributes
    XCTAssert(traitReference.physicalAttributes.contains("Dexterity"))
    XCTAssert(traitReference.socialAttributes.contains("Composure"))
    XCTAssert(traitReference.mentalAttributes.contains("Intelligence"))
    
    // Test random descriptions
    let description = traitReference.description(forTrait: "Dexterity")
    XCTAssert(description == "Represents a character’s agility, precision, and grace.", String(describing: description))
  }
  
  func testSkills() {
    let traitReference = TraitReference()
    
    // Test skill counts
    XCTAssert(traitReference.physicalSkills.count == 9)
    XCTAssert(traitReference.socialSkills.count == 9)
    XCTAssert(traitReference.mentalSkills.count == 9)
    
    // Test existence of three random skills
    XCTAssert(traitReference.physicalSkills.contains("Brawl"))
    XCTAssert(traitReference.socialSkills.contains("Animal Ken"))
    XCTAssert(traitReference.mentalSkills.contains("Science"))
    
    // Test random descriptions
    XCTAssert(traitReference.description(forTrait: "Craft") == "Represents the ability to create both artwork and functional items. (Free specialty.)")
    XCTAssert(traitReference.description(forTrait: "Medicine") == "Useful for doctors and nurses, Medicine allows you to heal the sick and injured and understand causes of death. Medicine is used to heal Aggravated Damage in mortals.")
  }
  
}
