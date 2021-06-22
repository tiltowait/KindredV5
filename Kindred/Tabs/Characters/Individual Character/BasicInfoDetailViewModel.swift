//
//  BasicInfoDetailViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/16/21.
//

import Foundation

extension BasicInfoDetail {
  class ViewModel: BaseKindredViewModel {
    
    /// Whether the disclosure is/should be expanded or not.
    @Published var isExpanded: Bool {
      willSet {
        UserDefaults.standard.set(newValue, forKey: autosaveKey)
      }
    }
    
    /// The kindred's birthdate.
    @Published var birthdate: Date {
      willSet {
        kindred.birthdate = newValue
      }
    }
    
    /// The date of the kindred's embrace.
    @Published var transitionDate: Date {
      didSet {
        kindred.embraceDate = transitionDate
      }
    }
    
    var benefactorTerm: String? {
      if kindred.clan?.template == .kindred {
        return "Sire"
      } else if kindred.clan?.template == .ghoul {
        return "Domitor"
      }
      return nil
    }
    
    var transitionTerm: String? {
      if kindred.clan?.template == .kindred {
        return "Embraced"
      } else if kindred.clan?.template == .ghoul {
        return "Ghouled"
      }
      return nil
    }
    
    let birthdateRange = ...Date()
    var embraceRange: ClosedRange<Date> {
      birthdate...Date()
    }
    
    /// The name used for storing `isExpanded` in `UserDefaults`.
    ///
    /// The name is derived from the Kindred's `id` property, plus an additonal
    /// string for namespacing.
    private let autosaveKey: String
    
    override init(kindred: Kindred) {
      // Core Data doesn't let us specify the current date as a default, so we
      // do it here
      birthdate = kindred.birthdate ?? Date()
      transitionDate = kindred.embraceDate ?? Date()
      
      autosaveKey = "\(kindred.id.hashValue)_AdditionalDetailsExpansion"
      isExpanded = UserDefaults.standard.bool(forKey: autosaveKey)
      
      super.init(kindred: kindred)
    }
    
    
    
    
    
  }
}
