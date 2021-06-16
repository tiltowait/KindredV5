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
        UserDefaults.standard.set(newValue, forKey: autosaveName)
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
    
    /// The name used for storing `isExpanded` in `UserDefaults`
    ///
    /// Technically, there is a storage leak here. If the user renames their character, this
    /// key hangs around. However, a bool being what it is, it will take a great deal of
    /// renames for the user to even notice it.
    private let autosaveName: String
    
    override init(kindred: Kindred) {
      birthdate = kindred.birthdate ?? Date()
      embraceDate = kindred.embraceDate ?? Date()
      
      autosaveName = "\(kindred.name)_AdditionalDetailsExpansion"
      isExpanded = UserDefaults.standard.bool(forKey: autosaveName)
      
      super.init(kindred: kindred)
    }
    
    
    
    
    
  }
}
