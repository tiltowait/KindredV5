//
//  ChronicleDetailViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/12/21.
//

import Foundation

extension ChronicleDetail {
  class ViewModel: BaseSavingKindredViewModel {
    
    enum MoralityItem {
      case tenet
      case conviction
      case touchstone
    }
    
    @Published var chronicle: String
    @Published var inGameDate: Date
    @Published var tenets: [String]
    @Published var convictions: [String]
    @Published var touchstones: [String]
    
    @Published var errorMessage: String? = nil
    
    override init(kindred: Kindred, dataController: DataController) {
      chronicle = kindred.chronicle
      inGameDate = kindred.inGameDate ?? Date()
      
      if kindred.chronicleTenets.isEmpty {
        tenets = []
      } else {
        tenets = kindred.chronicleTenets.components(separatedBy: .newlines)
      }
      if kindred.convictions.isEmpty {
        convictions = []
      } else {
      convictions = kindred.convictions.components(separatedBy: .newlines)
      }
      if kindred.touchstones.isEmpty {
        touchstones = []
      } else {
        touchstones = kindred.touchstones.components(separatedBy: .newlines)
      }
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    func add(_ moralityItem: MoralityItem) {
      print("Adding!")
      switch moralityItem {
      case .tenet: tenets.append("")
      case .conviction: convictions.append("")
      case .touchstone:
        if touchstones.count < convictions.count {
          touchstones.append("")
        } else {
          errorMessage = "Add a conviction before adding another touchstone."
        }
      }
    }
    
    func removeTenet(_ offsets: IndexSet) {
      tenets.remove(atOffsets: offsets)
    }
    
    func removeConviction(_ offsets: IndexSet) {
      convictions.remove(atOffsets: offsets)
    }
    
    func removeTouchstone(_ offsets: IndexSet) {
      touchstones.remove(atOffsets: offsets)
    }
    
    func commitChanges() {
      kindred.chronicle = chronicle
      kindred.inGameDate = inGameDate
      kindred.chronicleTenets = tenets.joined(separator: "\n")
      kindred.convictions = convictions.joined(separator: "\n")
      kindred.touchstones = touchstones.joined(separator: "\n")
      
      super.save()
    }
  }
}
