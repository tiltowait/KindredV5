//
//  RandomAccessCollection+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import Foundation

extension Array {
  
  /// Pops a random element from the array.
  /// - Returns: The popped element, or nil if the array is empty.
  mutating func popRandom() -> Element? {
    if self.isEmpty { return nil }
    
    let randomIndex = Int.random(in: 0..<self.count)
    return self.remove(at: randomIndex)
  }
  
}
