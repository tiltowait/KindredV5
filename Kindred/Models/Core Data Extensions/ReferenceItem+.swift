//
//  ReferenceItem+.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/25/21.
//

import Foundation

extension ReferenceItem {
  
  /// The source book from which the item originates.
  var sourceBook: Global.Source {
    Global.Source(rawValue: source) ?? .core
  }
  
  var pageReference: String {
    sourceBook.reference(page: self.page)
  }
  
}
