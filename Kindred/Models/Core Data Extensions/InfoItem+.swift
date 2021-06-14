//
//  InfoItem+.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/25/21.
//

import Foundation

// Convenience accessors for InfoItems

extension InfoItem {
  
  /// The item's name.
  var name: String {
    get { zName! }
    set { zName = newValue }
  }
  
  /// The item's flavor text/description.
  var info: String {
    get { zInfo! }
    set { zInfo = newValue }
  }
  
}
