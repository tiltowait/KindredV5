//
//  Constants.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import SwiftUI

/// Global enums and constants used throughout the app.
enum Global {
  
  /// Enums and constants pertaining to advantages.
  enum Advantage {
    /// The general "type" of an advantage, such as loresheet or background.
    enum Category: Int {
      /// The advantage is a background.
      case background
      /// The advantage is a merit.
      case merit
      /// The advantage is a loresheet.
      case loresheet
    }
  }
  
  /// The source book for a given power, advantage, predator type, ritual, etc.
  enum Source: Int16 {
    /// Item comes from the V5 core rulebook.
    case core
    /// Item comes from the Camarilla book.
    case camarilla
    /// Item comes from the Anarch book.
    case anarch
    /// Item comes from Chicago by Night.
    case chicagoByNight
    /// Item comes from The Fall of London.
    case fallOfLondon
    /// Item comes from The Chicago Folios.
    case chicagoFolios
    /// Item comes from the V5 Companion.
    case companion
    /// Item comes from Cults of the Blood Gods.
    case cultsOfTheBloodGods
    /// Item comes from Children of the Blood.
    case childrenOfTheBlood
    
    /// The full title of the referenced sourcebook.
    var title: String {
      switch self {
      case .core: return "V5 Core"
      case .camarilla: return "Camarilla"
      case .anarch: return "Anarch"
      case .chicagoByNight: return "Chicago by Night"
      case .fallOfLondon: return "The Fall of London"
      case .chicagoFolios: return "The Chicago Folios"
      case .companion: return "V5 Companion"
      case .cultsOfTheBloodGods: return "Cults of the Blood Gods"
      case .childrenOfTheBlood: return "Children of the Blood"
      }
    }
    
    var color: Color {
      switch self {
      case .core: return .core
      case .companion: return .companion
      case .cultsOfTheBloodGods: return .cultsOfTheBloodGods
      default: return .unknownSource
      }
    }
    
    /// Generate a page reference string. <Book title>, p.<page>.
    /// - Parameter page: The page number for the reference.
    /// - Returns: The formatted page reference.
    func reference(page: Int16) -> String {
      "\(self.title), p.\(page)"
    }
  }
  
  enum Ritual {
    enum Kind: Int {
      case ritual
      case ceremony
    }
  }
  
}
