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
  
}
