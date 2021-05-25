//
//  Color+.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/25/21.
//

import SwiftUI

/// Conveniently named colors for representing different source books.
extension Color {
  
  /// The color associated with the core rulebook.
  static let core = Color.clear
  
  /// The color associated with the V5 Companion.
  static let companion = Color("Companion")
  
  /// The color associated with Cults of the Blood Gods.
  static let cultsOfTheBloodGods = Color("Cults")
  
  /// The color for when a source book is unknown. A nice, disgusting brown.
  static let unknownSource = Color("Unknown")
  
}
