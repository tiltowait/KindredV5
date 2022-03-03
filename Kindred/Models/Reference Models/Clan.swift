//
//  Clan.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

class Clan: ReferenceItem {
  enum Template: Int16 {
    case kindred
    case ghoul
    case mortal
  }
  
  let id: Int16
  let name: String
  let info: String
  let page: Int16
  let source: Int16
  let bane: String
  let compulsion: String
  let compulsionDetails: String
  let rawTemplate: Int16
  let header: String
  let icon: String
  let nicknames: [String]
  
  let inClanDisciplines: [Discipline]
  
  var template: Template {
    guard let template = Template(rawValue: self.rawTemplate) else {
      fatalError("\(name): Unknown template: \(self.rawTemplate)")
    }
    return template
  }
  
  init(id: Int16, name: String, info: String, page: Int16, source: Int16, bane: String, compulsion: String, compulsionDetails: String, rawTemplate: Int16, header: String, icon: String, nicknames: String, inClanDisciplines: [Discipline]) {
    self.id = id
    self.name = name
    self.info = info
    self.page = page
    self.source = source
    self.bane = bane
    self.compulsion = compulsion
    self.compulsionDetails = compulsionDetails
    self.rawTemplate = rawTemplate
    self.header = header
    self.icon = icon
    self.nicknames = nicknames.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    self.inClanDisciplines = inClanDisciplines
  }
  
  func randomNicknames(count: Int) -> [String] {
    var nicknames = self.nicknames
    return (0..<count).compactMap { _ in nicknames.popRandom() }
  }
}
