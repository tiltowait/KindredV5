//
//  BaseKindredViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import Foundation

class BaseKindredViewModel: ObservableObject {
  
  @Published var kindred: Kindred
  let dataController: DataController
  
  init(kindred: Kindred, dataController: DataController) {
    self.kindred = kindred
    self.dataController = dataController
  }
  
  /// Saves any changes made to the managed `Kindred` object.
  func save() {
    dataController.save()
  }
  
}
