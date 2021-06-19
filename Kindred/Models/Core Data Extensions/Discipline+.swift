//
//  Discipline+.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import Foundation
import CoreData

// MARK: - Convenience Accessors
extension Discipline {
  
  /// An `NSFetchRequest` with an alphabetical sort descriptor.
  static var sortedFetchRequest: NSFetchRequest<Discipline> {
    let request: NSFetchRequest<Discipline> = Discipline.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Discipline.zName, ascending: true)]
    return request
  }
  
  static func fetchDiscipline(
    named name: String,
    in context: NSManagedObjectContext
  ) -> Discipline? {
    let request: NSFetchRequest<Discipline> = Self.fetchRequest()
    request.predicate = NSPredicate(format: "name = %@", name)
    request.fetchLimit = 1
    
    return try? context.fetch(request).first
  }
  
  var icon: String {
    get { self.zIcon! }
    set { self.zIcon = newValue }
  }
  
  /// An array of all `Powers`s associated with the `Discipline`, from all sources.
  var allPowers: [Power] {
    let powerArray = self.powers?.allObjects as? [Power] ?? []
    return powerArray.sorted()
  }
  
  /// Retrieve all `Power`s from a given `Source`.
  /// - Parameter source: The source book the user is interested in.
  /// - Returns: The powers from the `source`.
  func powers(fromSource source: Global.Source) -> [Power] {
    let rawSource = source.rawValue
    return allPowers.filter { $0.source == rawSource }
  }
  
}

extension Discipline: Comparable {
  
  static public func <(lhs: Discipline, rhs: Discipline) -> Bool {
    lhs.name < rhs.name
  }
  
}
