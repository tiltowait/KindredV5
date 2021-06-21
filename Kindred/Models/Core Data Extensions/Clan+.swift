//
//  Clan+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import Foundation
import CoreData

extension Clan {
  
  enum Template: Int16 {
    case kindred
    case ghoul
    case mortal
  }
  
  static var sortedFetchRequest: NSFetchRequest<Clan> {
    let request: NSFetchRequest<Clan> = Clan.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Clan.zName, ascending: true)]
    return request
  }
  
  var nicknames: [String] {
    let nicknames = zNicknames ?? ""
    return nicknames.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
  }
  
  var bane: String {
    get { zBane! }
    set { zBane = newValue }
  }
  
  var compulsion: String {
    get { zCompulsion! }
    set { zCompulsion = newValue }
  }
  
  var compulsionDetails: String {
    get { zCompulsionDetails! }
    set { zCompulsionDetails = newValue }
  }
  
  var icon: String {
    get { zIcon! }
    set { zIcon = newValue }
  }
  
  var header: String {
    get { zHeader! }
    set { zHeader = newValue }
  }
  
  var inClanDisciplines: [Discipline] {
    let disciplines = disciplines?.allObjects as? [Discipline] ?? []
    return disciplines.sorted()
  }
  
  var template: Template {
    guard let template = Template(rawValue: self.rawTemplate) else {
      fatalError("\(name): Unknown transition: \(self.template)")
    }
    return template
  }
  
  var transition: String? {
    switch template {
    case .kindred: return "Embraced"
    case .ghoul: return "Ghouled"
    default: return nil
    }
  }
  
  /// Retrieve random nicknames.
  /// - Parameter count: The number of nicknames to retrieve.
  func randomNicknames(count: Int) -> [String] {
    var nicknames = self.nicknames
    return (0..<count).compactMap { _ in nicknames.popRandom() }
  }
  
}
