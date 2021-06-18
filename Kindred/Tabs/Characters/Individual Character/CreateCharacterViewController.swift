//
//  CreateCharacterViewController.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import Foundation

extension CreateCharacterView {
  class ViewModel: ObservableObject {
    
    private let dataController: DataController
    
    @Published var name = ""
    @Published var concept = ""
    @Published var ambition = ""
    @Published var desire = ""
    @Published var birthdate = Date()
    
    /// Whether enough information has been given to create the character.
    var isCreatable: Bool {
      return !name.isEmpty
    }
    
    init(dataController: DataController) {
      self.dataController = dataController
    }
    
    /// Creates the character and saves the data.
    func createCharacter() {
      let character = Kindred(context: dataController.container.viewContext)
      character.name = name
      character.concept = concept
      character.ambition = ambition
      character.desire = desire
      character.birthdate = birthdate
      
      dataController.save()
    }
    
  }
}
