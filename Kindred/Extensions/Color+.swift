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
  static let core = Color.secondary
  
  /// The color associated with the V5 Companion.
  static let companion = Color("Companion")
  
  /// The color associated with Cults of the Blood Gods.
  static let cultsOfTheBloodGods = Color("Cults")
  
  /// The color for when a source book is unknown. A nice, disgusting brown.
  static let unknownSource = Color("Unknown")
  
  /// The color for content layered on top of secondary backgrounds of your grouped interface.
  static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
  
  /// The brand color.
  static let vampireRed = Color("Vampire Red")
  
  /// The color for the main background of your interface.
  static let systemBackground = Color(UIColor.systemBackground)
  
  /// The color for content layered on top of the main background.
  static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
  
  /// The color for placeholder text in controls or text views.
  static let placeholderText = Color(UIColor.placeholderText)
  
  static let lightBlue = Color("Light Blue")
}
