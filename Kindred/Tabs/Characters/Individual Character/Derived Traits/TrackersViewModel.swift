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
      objectWillChange.send()
      kindred.healthString = ".\(kindred.healthString)"
    }
    
    func decrementHealth() {
      objectWillChange.send()
      kindred.healthString = String(kindred.healthString.dropFirst())
    }
    
    func incrementWillpower() {
      objectWillChange.send()
      kindred.willpowerString = ".\(kindred.willpowerString)"
    }
    
    func decrementWillpower() {
      objectWillChange.send()
      kindred.willpowerString = String(kindred.willpowerString.dropFirst())
    }
    
    func incrementBloodPotency() {
//      kindred.bloodPotency += 1
      NotificationCenter.default.post(name: .bloodPotencyChanged, object: nil)
    }
    
    func decrementBloodPotency() {
//      kindred.bloodPotency -= 1
      NotificationCenter.default.post(name: .bloodPotencyChanged, object: nil)
    }
    
    /// Perform a rouse check, increasing hunger as necessary.
    /// - Returns: Whether the check was successful (no hunger increase) or not.
    func rouse(checks: Int) -> Bool {
      objectWillChange.send()
      let successful = (1...checks).map { _ in Bool.random() }.contains(true)
      
      if !successful {
        kindred.hunger += 1
      }
      
      return successful
    }
    
  }
}
