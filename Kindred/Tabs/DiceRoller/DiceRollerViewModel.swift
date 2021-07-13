//
//  DiceRollerViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/13/21.
//

import Foundation

extension DiceRoller {
  class ViewModel: ObservableObject {
    
    @Published var pool = 5
    @Published var hunger = 1
    @Published var difficulty = 3
    
    let poolRange = Array(1...30)
    let hungerRange = Array(0...5)
    let difficultyRange = Array(1...15)
    
  }
}
