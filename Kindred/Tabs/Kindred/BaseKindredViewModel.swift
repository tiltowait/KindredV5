//
//  BaseKindredViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/16/21.
//

import Foundation

class BaseKindredViewModel: ObservableObject {
  
  @Published var kindred: Kindred
  
  init(kindred: Kindred) {
    self.kindred = kindred
  }
  
}
