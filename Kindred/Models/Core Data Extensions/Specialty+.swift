//
//  Specialty+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/13/21.
//

import Foundation

extension Specialty {
  
  var skillName: String {
    get { zSkillName ?? "" }
    set { zSkillName = newValue }
  }
  
  var specialties: [String] {
    get { zSpecialties!.components(separatedBy: "\n") }
    set { zSpecialties = newValue.joined(separator: "\n") }
  }
  
  var formatted: String {
    specialties.joined(separator: ", ")
  }
  
}
