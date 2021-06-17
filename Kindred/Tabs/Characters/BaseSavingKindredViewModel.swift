//
//  BaseSavingKindredViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import Foundation

class BaseSavingKindredViewModel: BaseKindredViewModel {
  
  let dataController: DataController
  
  init(kindred: Kindred, dataController: DataController) {
    self.dataController = dataController
    super.init(kindred: kindred)
  }
  
  /// Saves any changes made to the managed `Kindred` object.
  func save() {
    dataController.save()
  }
  
}
