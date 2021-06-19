//
//  OptionalKindredViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import Foundation

class OptionalKindredViewModel: ObservableObject {
  
  @Published var kindred: Kindred?
  let dataController: DataController?
  
  init(kindred: Kindred?, dataController: DataController?) {
    self.kindred = kindred
    self.dataController = dataController
  }
  
  /// Saves any changes to persistent storage.
  func save() {
    dataController?.save()
  }
  
}
