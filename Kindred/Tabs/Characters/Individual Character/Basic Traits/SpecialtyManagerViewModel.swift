//
//  SpecialtyManagerViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/13/21.
//

import Foundation

extension SpecialtyManager {
  class ViewModel: BaseSavingKindredViewModel {
    
    @Published var specialties: [String]
    let skill: String
    
    init(skill: String, kindred: Kindred, dataController: DataController) {
      self.skill = skill
      self.specialties = kindred.specialties(for: skill) ?? []
      super.init(kindred: kindred, dataController: dataController)
    }
    
    func removeSpecialties(_ offsets: IndexSet) {
      specialties.remove(atOffsets: offsets)
    }
    
    /// Apply the specialties to the character's skill and return the new formatted specialty string.
    /// - Returns: The new formatted specialty string.
    func commitChanges() -> String? {
      // We don't want to keep any empty specialties
      let specialties = specialties.filter { !$0.isEmpty }
      
      let specialty: Specialty
      if let container = (kindred.allSpecialties.first { $0.skillName == skill }) {
        specialty = container
      } else {
        specialty = Specialty(context: dataController.container.viewContext)
      }
      specialty.skillName = skill
      specialty.specialties = specialties
      specialty.parent = kindred
      
      let formattedSpecialties = specialties.joined(separator: ", ")
      return formattedSpecialties.isEmpty ? nil : formattedSpecialties
    }
    
  }
}
