//
//  CharacterListViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import CoreData

extension CharacterList {
  class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    
    private let characterController: NSFetchedResultsController<Kindred>
    let dataController: DataController
    
    @Published var unknown: [Kindred] = []
    @Published var kindred: [Kindred] = []
    @Published var ghouls: [Kindred] = []
    @Published var mortals: [Kindred] = []
    
    @Published var showingCreationSheet = false
    @Published var unlockIdentifier: String?
    
    /// Whether the user has added any characters to the app.
    var hasCharacters: Bool {
      if let characters = characterController.fetchedObjects {
        return !characters.isEmpty
      } else {
        return false
      }
    }
    
    init(dataController: DataController) {
      self.dataController = dataController
      
      // Construct a fetch request to show all characters
      let request: NSFetchRequest<Kindred> = Kindred.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(keyPath: \Kindred.zName, ascending: true)]
      
      characterController = NSFetchedResultsController(
        fetchRequest: request,
        managedObjectContext: dataController.container.viewContext,
        sectionNameKeyPath: nil,
        cacheName: nil
      )
      
      super.init()
      
      characterController.delegate = self
      
      do {
        try characterController.performFetch()
        updateArrays(with: characterController.fetchedObjects ?? [])
      } catch {
        fatalError("Failed to fetch initial data.\n\(error.localizedDescription)")
      }
    }
    
    /// Determine whether to show the character creation sheet or the IAP sheet.
    func addCharacter() {
      // Check the IAP status
      if dataController.unlockedUnlimited == false && self.hasCharacters {
        unlockIdentifier = dataController.unlockUnlimitedIdentifier
      } else {
        showingCreationSheet.toggle()
      }
    }
    
    // MARK: - Data Manipulation
    
    /// Delete the indicated characters from the given list.
    /// - Parameters:
    ///   - offsets: The indices of the characters to delete.
    ///   - characters: The characters list of characters to delete from.
    func delete(_ offsets: IndexSet, from characters: [Kindred]) {
      for offset in offsets {
        dataController.delete(characters[offset])
        NotificationCenter.default.post(name: .characterWasDeleted, object: nil)
      }
      save()
    }
    
    /// Save the data.
    func save() {
      dataController.save()
    }
    
    
    // MARK: - Delegation
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      updateArrays(with: controller.fetchedObjects as? [Kindred] ?? [])
    }
    
    /// Updates the various character arrays with the supplied values.
    /// - Parameter characters: The new characters to filter into the arrays.
    private func updateArrays(with characters: [Kindred]) {
      // Technically, it might be more efficient to reset all the arrays, then loop over the
      // characters list and add to the arrays one at a time. With that method, we would only
      // loop over the array once. However, given that the characters array will be small
      // (no more than two digits for 99.99% of uses), this clearer, if less efficient, method
      // is being used.
      
      unknown = characters.filter { $0.clan == nil }
      kindred = characters.filter { $0.clan?.template == .kindred }
      ghouls = characters.filter { $0.clan?.template == .ghoul }
      mortals = characters.filter { $0.clan?.template == .mortal }
    }
    
  }
}
