//
//  Ritual+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/27/21.
//

import Foundation

extension Ritual {
  
  var process: String {
    get { zProcess ?? "" }
    set { zProcess = newValue }
  }
  
  var system: String {
    get { zSystem ?? "" }
    set { zSystem = newValue }
  }
  
}
