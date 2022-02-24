//
//  URL+.swift
//  Kindred
//
//  Created by Jared Lindsay on 2/23/22.
//

import Foundation

extension URL {
  /// The user's documents directory.
  static var documents: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
