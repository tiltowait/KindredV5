//
//  URL+.swift
//  Kindred
//
//  Created by Jared Lindsay on 2/23/22.
//

import Foundation

extension URL {
  /// The user's documents directory.
  static var localDocuments: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  /// The iCloud documents directory.
  static var cloudDocuments: URL? {
    FileManager.default.url(forUbiquityContainerIdentifier: nil)
  }
  
  /// Either the user's local documents directory or, if available, the iCloud documents directory.
  static var documents: URL {
    cloudDocuments ?? localDocuments
  }
  
  /// Whether the URL is a local or iCloud URL.
  var isLocal: Bool {
    !self.path.contains("Library/Mobile Documents/")
  }
}
