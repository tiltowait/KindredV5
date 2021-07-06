//
//  Importer.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import CoreData
import Foundation

enum ImportError: Error {
  case invalidReference(String)
}

/// An object responsible for importing a particular class of data.
protocol Importer {
  
  /// Attempt to import or update all of the objects for which the importer is responsible that have
  /// a reference database version higher than the Core Data store's version.
  ///
  /// This function does not save the data.
  /// - Parameters:
  ///   - currentVersion: The current version of the Core Data store.
  ///   - context: The context for storing the data.
  static func importAll(after currentVersion: Int, context: NSManagedObjectContext) throws
  
}
