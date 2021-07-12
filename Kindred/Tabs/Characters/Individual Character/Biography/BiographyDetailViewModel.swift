//
//  BiographyDetailViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/12/21.
//

import Foundation

extension BiographyDetail {
  class ViewModel: BaseSavingKindredViewModel {
    
    @Published var appearance: String
    @Published var distinguishingFeatures: String
    @Published var history: String
    @Published var possessions: String
    
    @Published var inGameDate: Date
    @Published var birthdate: Date
    @Published var transitionDate: Date
    
    @Published var benefactor: String
    
    @Published var height: String
    @Published var weight: String
    
    let transitionTerm: String?
    let benefactorTerm: String
    
    var apparentAge: String {
      guard let birthdate = kindred.birthdate,
            let embraceDate = kindred.embraceDate,
            let age = Calendar.current.dateComponents([.year], from: birthdate, to: embraceDate).year
      else {
        return "Unknown"
      }
      return String(age)
    }
    
    var trueAge: String {
      guard let birthdate = kindred.birthdate,
            let inGameDate = kindred.inGameDate,
            let age = Calendar.current.dateComponents([.year], from: birthdate, to: inGameDate).year
      else {
        return "Unknown"
      }
      return String(age)
    }
    
    override init(kindred: Kindred, dataController: DataController) {
      appearance = kindred.appearance
      distinguishingFeatures = kindred.distinguishingFeatures
      history = kindred.history
      possessions = kindred.possessions
            
      if kindred.clan?.template == .kindred {
        transitionTerm = "Embraced"
      } else if kindred.clan?.template == .ghoul {
        transitionTerm = "Ghouled"
      } else {
        transitionTerm = nil
      }
      
      inGameDate = kindred.inGameDate ?? Date()
      birthdate = kindred.birthdate ?? Date().addingTimeInterval(-568_036_800) // 18 years ago
      transitionDate = kindred.embraceDate ?? Date()
      
      if kindred.clan?.template == .kindred {
        transitionDate = kindred.embraceDate ?? Date()
      }
      
      // Mortals don't have a benefactor, but this will never be displayed if the character
      // isn't a vampire or a ghoul.
      benefactorTerm = kindred.clan?.template == .kindred ? "Sire" : "Domitor"
      benefactor = kindred.sire
      
      height = kindred.height
      weight = kindred.weight
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    func commitChanges() {
      kindred.appearance = appearance
      kindred.distinguishingFeatures = distinguishingFeatures
      kindred.history = history
      kindred.possessions = possessions
      
      kindred.sire = benefactor
      kindred.height = height
      kindred.weight = weight
      
      kindred.inGameDate = inGameDate
      kindred.birthdate = birthdate
      if transitionTerm != nil {
        kindred.embraceDate = transitionDate
      }
      
      self.save()
    }
    
  }
}
