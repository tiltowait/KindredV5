//
//  TrackersViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/24/21.
//

import Foundation

extension Trackers {
  class ViewModel: BaseKindredViewModel {
    
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
    
  }
}
