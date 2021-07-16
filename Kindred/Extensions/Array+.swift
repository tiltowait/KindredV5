//
//  Array+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/16/21.
//
//  Taken from https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks on 7/16/21.

import Foundation

extension Array {
  
  /// Returns the first `k` items of the array.
  /// - Parameter k: The number of items to return.
  /// - Returns: The items. If `k` is larger than the array, it will return the entire array.
  func first(_ k: Int) -> [Element] {
    if k >= count {
      return self
    }
    
    return Array(dropLast(count - k))
  }
  
}
