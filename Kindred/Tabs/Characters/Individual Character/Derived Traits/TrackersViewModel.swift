//
//  TrackersViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/24/21.
//

import Foundation

extension Trackers {
  class ViewModel: BaseKindredViewModel {
    
    var canRouse: Bool {
      kindred.hunger < 5
    }
    
    func incrementHealth() {
      kindred.healthString = ".\(kindred.healthString)"
    }
    
    func decrementHealth() {
      kindred.healthString = String(kindred.healthString.dropFirst())
    }
    
    func incrementWillpower() {
      kindred.willpowerString = ".\(kindred.willpowerString)"
    }
    
    func decrementWillpower() {
      kindred.willpowerString = String(kindred.willpowerString.dropFirst())
    }
    
    /// Perform a rouse check, increasing hunger as necessary.
    /// - Returns: Whether the check was successful (no hunger increase) or not.
    func rouseCheck() -> Bool {
      let rouseResult = Bool.random()
      
      if !rouseResult {
        kindred.hunger += 1
      }
      
      return rouseResult
    }
    
  }
}
