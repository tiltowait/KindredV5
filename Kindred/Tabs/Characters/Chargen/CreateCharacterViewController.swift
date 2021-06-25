//
//  CreateCharacterViewController.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import Foundation

extension CreateCharacterView {
  class ViewModel: ObservableObject {
    
    let dataController: DataController
    
    @Published var name = ""
    @Published var concept = ""
    @Published var ambition = ""
    @Published var desire = ""
    @Published var birthdate = Date()
    
    // We want to force the user to select a clan before they can create the character; however,
    // clan selection requires a character to already be made. Therefore, we create a dummy
    // character for that selection. This character is only created upon selecting a clan, and
    // it is deleted after the data is saved.
    @Published var dummyCharacter: Kindred? = nil
    @Published var showingClanSheet = false
    @Published var selectedClan = "Tap to select"
    
    var clanIsSelected: Bool {
      dummyCharacter?.clan != nil
    }
    
    /// Whether enough information has been given to create the character.
    var isCreatable: Bool {
      return !name.isEmpty && dummyCharacter?.clan != nil
    }
    
    init(dataController: DataController) {
      self.dataController = dataController
      
      // When the user creates a character, dummyCharacter is set to nil and the view is dismissed.
      // If we have selectedClan as a computed property based on dummyCharacter?.clan, then the
      // user will see the clan change to "Tap to select" as the view is sliding away. To prevent
      // this behavior, we register for the didSelectClan notification and store the value of the
      // clan's name. That way, the clan name stays visible until the view completely disappears.
      
      NotificationCenter.default.addObserver(self, selector: #selector(clanWasSelected), name: .didSelectClan, object: nil)
    }
    
    func showClanSheet() {
      dummyCharacter = Kindred(context: dataController.container.viewContext)
      showingClanSheet.toggle()
    }
    
    /// Applies the character data and saves.
    func createCharacter() {
      guard dummyCharacter != nil else { return }
      
      // If we simply use the dummy character instead of creating a new one, this causes an issue
      // where the character's name doesn't show up in the list. Further research is necessary, but
      // this could be a bug in SwiftUI.
      
      let character = Kindred(context: dataController.container.viewContext)
      character.name = name
      character.concept = concept
      character.ambition = ambition
      character.desire = desire
      character.birthdate = birthdate
      character.clan = dummyCharacter?.clan
      
      self.deleteDummy()
      dataController.save()
    }
    
    /// Delete the character.
    func deleteDummy() {
      if let dummyCharacter = dummyCharacter {
        dataController.delete(dummyCharacter)
        self.dummyCharacter = nil
      }
    }
    
    @objc func clanWasSelected(_ notification: Notification) {
      if dummyCharacter != nil {
        selectedClan = dummyCharacter?.clan?.name ?? "Tap to select"
      }
    }
    
  }
}
