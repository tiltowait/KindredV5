//
//  Constants.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import SwiftUI
import CoreHaptics

/// Global enums and constants used throughout the app.
enum Global {
  
  enum TraitType: String {
    case attributes
    case skills
  }
  
  static let pdfDPI: CGFloat = 250
  
  /// The path to the reference database.
  static let referenceDatabasePath: String = {
    guard let path = Bundle.main.path(forResource: "reference", ofType: "sqlite") else {
      fatalError("Unable to locate reference database!")
    }
    return path
  }()
  
  static let referenceVersionKey = "referenceVersion"
  
  /// A simple, sharp haptic tap pattern.
  private static let hapticTapPattern: CHHapticPattern? = {
    do {
      let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
      let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
      let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
      let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)
      let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, end], relativeTime: 0)
      
      let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
      
      let pattern = try CHHapticPattern(events: [event], parameterCurves: [parameter])

      return pattern
    } catch {
      return nil
    }
  }()
  
  /// Provide a quick, sharp haptic tap.
  /// - Parameter engine: The haptic engine to use.
  static func hapticTap(engine: CHHapticEngine?) {
    guard let tap = Global.hapticTapPattern else { return }
    
    do {
      try engine?.start()
      
      let player = try engine?.makePlayer(with: tap)
      try player?.start(atTime: 0)
    } catch { }
  }
  
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
    /// Item comes from Trails of Ash and Bone.
    case trailsOfAshAndBone
    
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
      case .trailsOfAshAndBone: return "Trails of Ash and Bone"
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
    
    var unlockIdentifier: String {
      switch self {
      case .core: return "included"
      case .camarilla: return "com.tiltowait.Kindred.camarilla"
      case .anarch: return "com.tiltowait.Kindred.anarch"
      case .chicagoByNight: return "com.tiltowait.Kindred.chicagoByNight"
      case .fallOfLondon: return "com.tiltowait.Kindred.fallOfLondon"
      case .chicagoFolios: return "com.tiltowait.Kindred.chicagoFolios"
      case .companion: return "included"
      case .cultsOfTheBloodGods: return "com.tiltowait.Kindred.cults"
      case .childrenOfTheBlood: return "com.tiltowait.Kindred.childrenOfTheBlood"
      case .trailsOfAshAndBone: return "com.tiltowait.Kindred.trailsOfAshAndBone"
      }
    }
    
    /// Generate a page reference string. <Book title>, p.<page>.
    /// - Parameter page: The page number for the reference.
    /// - Returns: The formatted page reference.
    func reference(page: Int16) -> String {
      "\(self.title), p.\(page)"
    }
  }
  
}
