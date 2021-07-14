//
//  Comparable+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/14/21.
//
//  Taken from https://www.hackingwithswift.com/articles/141/8-useful-swift-extensions on 7/14/21.

import Foundation

extension Comparable {
  func clamp(low: Self, high: Self) -> Self {
    if (self > high) {
      return high
    } else if (self < low) {
      return low
    }
    
    return self
  }
}
