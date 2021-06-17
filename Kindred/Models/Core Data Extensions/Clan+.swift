//
//  Clan+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import Foundation

extension Clan {
  
  var inClanDisciplines: [Discipline] {
    let disciplines = disciplines?.allObjects as? [Discipline] ?? []
    return disciplines.sorted()
  }
  
}
