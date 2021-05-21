//
//  Discipline+.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import Foundation

extension Discipline {
  
  /// An array of all `Powers`s associated with the `Discipline`, from all sources.
  var allPowers: [Power] {
    self.powers?.allObjects as? [Power] ?? []
  }
  
  /// Retrieve all `Power`s from a given `Source`.
  /// - Parameter source: The source book the user is interested in.
  /// - Returns: The powers from the `source`.
  func powers(fromSource source: Global.Source) -> [Power] {
    let rawSource = source.rawValue
    return allPowers.filter { $0.source == rawSource }
  }
  
}
