//
//  ImportTests.swift
//  KindredTests
//
//  Created by Jared Lindsay on 7/26/21.
//

import Foundation

import XCTest
@testable import Kindred

class ImportTests: XCTestCase {
  
  let mainPDF = CharacterPDF(url: Bundle.main.url(forResource: "Nadea Theron", withExtension: "pdf")!)!
  let noHavenPDF = CharacterPDF(url: Bundle.main.url(forResource: "No-Haven Nadea Import", withExtension: "pdf")!)!
  
  // MARK: - Tests
  
  func testImportPerformance() {
    let context = DataController.preview.container.viewContext
    
    measure {
      _ = CharacterImporter(pdf: mainPDF, context: context) { _ in }
    }
  }
  
  func testImportAdvantages() {
    let context = DataController.preview.container.viewContext
    CharacterImporter(pdf: mainPDF, context: context) { importer in
      let character = importer.character!
      
      XCTAssertFalse(character.advantageContainers.isEmpty, "The character should have some advantages.")
    }
    
  }
  
  
}
