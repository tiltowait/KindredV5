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
  
  /// Attempt to import all of the objects for which the importer is responsible.
  ///
  /// This function does not save the data.
  /// - Parameter context: The context for storing the data.
  static func importAll(context: NSManagedObjectContext) throws
  
}
