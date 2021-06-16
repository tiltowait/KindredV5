//
//  KindredBasicDisclosureViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/16/21.
//

import Foundation

extension KindredBasicDisclosure {
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
    @Published var embraceDate: Date {
      didSet {
        kindred.embraceDate = embraceDate
      }
    }
    
    /// The name used for storing `isExpanded` in `UserDefaults`.
    ///
    /// The name is derived from the Kindred's `id` property, plus an additonal string for namespacing.
    private let autosaveKey: String
    
    override init(kindred: Kindred) {
      birthdate = kindred.birthdate ?? Date()
      embraceDate = kindred.embraceDate ?? Date()
      
      autosaveKey = "\(kindred.id.hashValue)_AdditionalDetailsExpansion"
      isExpanded = UserDefaults.standard.bool(forKey: autosaveKey)
      
      super.init(kindred: kindred)
    }
    
    
    
    
    
  }
}
