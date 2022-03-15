//
//  Clan.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

final class Clan: ReferenceItem {
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
  let bane: String?
  let compulsion: String?
  let compulsionDetails: String?
  let rawTemplate: Int16
  let header: String
  let icon: String
  let nicknames: [String]
  
  var inClanDisciplines: [Discipline] = []
  
  var template: Template {
    guard let template = Template(rawValue: self.rawTemplate) else {
      fatalError("\(name): Unknown template: \(self.rawTemplate)")
    }
    return template
  }
  
  init(id: Int16, name: String, info: String, page: Int16, source: Int16, bane: String?, compulsion: String?, compulsionDetails: String?, rawTemplate: Int16, header: String, icon: String, nicknames: String) {
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
  }
  
  func randomNicknames(count: Int) -> [String] {
    var nicknames = self.nicknames
    return (0..<count).compactMap { _ in nicknames.popRandom() }
  }
}

extension Clan {
  static let unknown = Clan(id: -1, name: "Unknown", info: "Update your app to the latest version.", page: 0, source: 0, bane: nil, compulsion: nil, compulsionDetails: nil, rawTemplate: 1, header: "", icon: "", nicknames: "Unknown, Unknown, Unknown")
}

extension Clan: Comparable {
  static func < (lhs: Clan, rhs: Clan) -> Bool {
    lhs.name < rhs.name
  }
}
