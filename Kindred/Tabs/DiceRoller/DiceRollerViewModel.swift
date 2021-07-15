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
    
    @Published var diceBag: DiceBag?
    
    var allowRerollingFailures: Bool {
      diceBag?.rerollOptions.contains(.rerollFailures) ?? false
    }
    
    var allowMaximizingCriticals: Bool {
      diceBag?.rerollOptions.contains(.maximizeCriticals) ?? false
    }
    
    var allowAvoidingMessyCriticals: Bool {
      diceBag?.rerollOptions.contains(.avoidMessyCritical) ?? false
    }
    
    #if DEBUG
    init() {
      roll()
    }
    #endif
    
    /// Roll the dice!
    func roll() {
      diceBag = DiceBag(pool: pool, hunger: hunger, difficulty: difficulty)
    }
    
    /// Make a willpower re-roll.
    /// - Parameter method: The re-roll method to use.
    func reroll(strategy: DiceBag.RerollStrategy) {
      diceBag?.reroll(strategy: strategy)
    }
    
  }
}
