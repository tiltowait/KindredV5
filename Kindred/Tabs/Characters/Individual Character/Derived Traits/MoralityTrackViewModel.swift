//
//  MoralityTrackerViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/20/21.
//

import Foundation

extension MoralityTrack {
  class ViewModel: BaseKindredViewModel {
    
    @Published var track: [Character] {
      didSet {
        kindred.humanityString = String(track)
      }
    }
    
    var allowRemorse: Bool {
      let stains = self.track.count { $0 == "/" }
      let marked = self.track.count { $0 == "x" }
      
      return stains > 0 && marked == 0
    }
    
    var allowDegen: Bool {
      self.track.count { $0 == "x" } > 0
    }
    
    override init(kindred: Kindred) {
      self.track = Array(kindred.humanityString)
      
      super.init(kindred: kindred)
    }
    
    /// Promote the dot at the specified index to the next valid value.
    ///
    /// Humanity strings use `.` for empty, `o` for filled, `/` for stains,
    /// and `x` for filled with a stain.
    /// - Parameter index: The index of the character to promote.
    /// - Returns: Whether the dot at the index was successfully promoted.
    func promote(index: Int) -> Bool {
      let code: Character
      switch track[index] {
      case "o":
        // We only allow a "marked" dot ("x") when there are no
        // empty dots. Additionally, only the last filled dot
        // can be so marked.
        
        if index == track.lastIndex(of: "o")
            && (track.count { $0 == "." } == 0)
            && (track.count { $0 == "x" } == 0)
        {
          code = "x"
        } else {
          return false
        }
      case "/":
        code = "."
      case "x":
        code = "o"
      default:
        code = "/"
      }
      
      var newTrack = self.track
      newTrack[index] = code
      self.track = newTrack
      
      return true
    }
    
    /// Perform a remorse check, reducing humanity if necessary and clearing stains.
    /// - Returns: Whether the check resulted in remorse (no humanity loss).
    func remorseCheck() -> Bool {
      let pool = track.count { $0 == "." }.clamp(low: 1, high: 10)
      let successful = (1...pool).map { _ in Bool.random() }.contains(true)
      
      if successful {
        kindred.humanity = kindred.humanity // Setting this automatically clears stains
        self.track = Array(kindred.humanityString)
      } else {
        degen()
      }
      
      return successful
    }
    
    func degen() {
      kindred.humanity -= 1 // Automatically clears stains
      self.track = Array(kindred.humanityString)
    }
    
  }
}
