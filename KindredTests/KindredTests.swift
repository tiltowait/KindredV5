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
  
  func testDataControllerPerformance() {
    measure {
      let _ = DataController(inMemory: true)
    }
  }
  
  func testImportPerformance() {
    guard let url = Bundle.main.url(forResource: "Nadea Theron", withExtension: "pdf"),
          let pdf = CharacterPDF(url: url)
    else {
      fatalError("Unable to locate the test PDF.")
    }
    let context = DataController.preview.container.viewContext
    
    measure {
      CharacterImporter.importCharacter(pdf: pdf, context: context)
    }
  }
  
}
