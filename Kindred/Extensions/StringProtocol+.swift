//
//  StringProtocol+.swift
//  PDFo
//
//  Created by Jared Lindsay on 6/13/21.
//

import Foundation

extension StringProtocol {
  
  func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
    range(of: string, options: options)?.lowerBound
  }
  
  func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
    range(of: string, options: options)?.upperBound
  }
  
  func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
    ranges(of: string, options: options).map(\.lowerBound)
  }
  
  func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
    var result: [Range<Index>] = []
    var startIndex = self.startIndex
    while startIndex < endIndex,
          let range = self[startIndex...]
            .range(of: string, options: options) {
      result.append(range)
      startIndex = range.lowerBound < range.upperBound ? range.upperBound :
        index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
    }
    return result
  }
  
  /// The string with spaces before each capital letter. E.g. "aNiceDay" becomes "a Nice Day".
  ///
  /// This property is fairly naive and should not be used for general purposes. Certain strings, such as "aUIImage", will
  /// produce undesired output.
  var unCamelCased: String {
    if self.isEmpty { return "" }
    
    var newString = ""
    
    for character in self {
      if character.isUppercase {
        newString.append(" ")
      }
      newString.append(character)
    }
    return newString.trimmingCharacters(in: .whitespaces)
  }
  
}

extension String {
  
  /// Replace the character at a given index with a substring.
  /// - Parameters:
  ///   - index: The index of the character to replace.
  ///   - substring: The substring to replace it with.
  mutating func replace(_ index: Int, with substring: String) {
    self = self.prefix(index) + substring + self.dropFirst(index + 1)
  }
  
}

extension String: Identifiable {
  public var id: Int { self.hashValue }
}
