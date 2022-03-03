//
//  ReferenceProtocols.swift
//  Kindred
//
//  Created by Jared Lindsay on 3/3/22.
//

import Foundation

protocol InfoItem: Identifiable {
  var id: Int16 { get }
  var name: String { get }
  var info: String { get }
}

protocol ReferenceItem: InfoItem {
  var page: Int16 { get }
  var source: Int16 { get }
}

extension InfoItem {
  static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
}

extension ReferenceItem {
  /// The source book from which the item originates.
  var sourceBook: Global.Source {
    Global.Source(rawValue: source) ?? .core
  }
  
  var pageReference: String {
    sourceBook.reference(page: self.page)
  }
  
  var unlockIdentifier: String {
    sourceBook.unlockIdentifier
  }
}
