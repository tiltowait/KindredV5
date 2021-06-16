//
//  KeyPath+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import Foundation

extension KeyPath where Root: NSObject {
  
  var stringValue: String {
    NSExpression(forKeyPath: self).keyPath
  }
  
}
