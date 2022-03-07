//
//  KnownLoresheetGroupsViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import Foundation

extension KnownLoresheetGroups {
  class ViewModel: BaseKindredViewModel {
    
    @Published var knownLoresheets: [Loresheet]
    
    override init(kindred: Kindred) {
      knownLoresheets = kindred.knownLoresheets
      super.init(kindred: kindred)
      
      NotificationCenter.default.addObserver(self, selector: #selector(didPurchaseLoresheet), name: .didAddAdvantage, object: nil)
    }
    
    /// Fetch all loresheet entries for a particular loresheet that the Kindred prosseses.
    /// - Parameter loresheet: The loresheet in question.
    /// - Returns: All loresheet entries for the loresheet that the Kindred possesses.
    func entries(for loresheet: Loresheet) -> [LoresheetEntry] {
      kindred.entries(for: loresheet)
    }
    
    func removeEntry(at offset: IndexSet, loresheet: Loresheet) {
      guard let index = offset.first else { return }
      let knownEntries = kindred.entries(for: loresheet)
      let entry = knownEntries[index]
      
      kindred.removeLoresheetEntry(entry)
    }
    
    @objc func didPurchaseLoresheet(_ notification: Notification) {
      knownLoresheets = kindred.knownLoresheets
    }
    
  }
}

