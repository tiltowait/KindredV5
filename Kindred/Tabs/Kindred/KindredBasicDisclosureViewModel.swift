//
//  KindredBasicDisclosureViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/16/21.
//

import Foundation

extension KindredBasicDisclosure {
  class ViewModel: BaseKindredViewModel {
    
    private(set) lazy var dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.timeStyle = .none
      
      return formatter
    }()
    
    var showConcept: Bool {
      !kindred.concept.isEmpty
    }
    
    var showChronicle: Bool {
      !kindred.chronicle.isEmpty
    }
    
    var showSire: Bool {
      !kindred.sire.isEmpty
    }
    
    var showTitle: Bool {
      !kindred.title.isEmpty
    }
    
    var birthdate: String? {
      if let birthdate = kindred.zBirthDate {
        return dateFormatter.string(from: birthdate)
      }
      return nil
    }
    
    var embraceDate: String? {
      if let embraceDate = kindred.zEmbraceDate {
        return dateFormatter.string(from: embraceDate)
      }
      return nil
    }
    
  }
}
