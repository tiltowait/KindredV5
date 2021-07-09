//
//  Dictionary+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/9/21.
//

extension Dictionary {
  
  /// Create a dictionary by merging the key-value pairs of the given dictionaries.
  /// - Parameter dictionaries: The dictionaries to merge.
  /// - Returns: The merged dictionary.
  func merging(with dictionaries: [Key: Value]...) -> [Key: Value] {
    var merged = self
    for dictionary in dictionaries {
      merged.merge(dictionary) { current, _ in current }
    }
    return merged
  }
  
}
