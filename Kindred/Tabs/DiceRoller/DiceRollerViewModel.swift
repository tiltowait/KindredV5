//
//  DiceRollerViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/13/21.
//

import Foundation

extension DiceRoller {
  class ViewModel: ObservableObject {
    
    @Published var pool: Int {
      didSet {
        UserDefaults.standard.setValue(pool, forKey: Self.poolKey)
      }
    }
    @Published var hunger: Int {
      didSet {
        UserDefaults.standard.setValue(hunger, forKey: Self.hungerKey)
      }
    }
    @Published var difficulty: Int {
      didSet {
        UserDefaults.standard.setValue(difficulty, forKey: Self.difficultyKey)
      }
    }
    
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
    
    init() {
      // We use value(forKey:) instead of integer(forKey:) so we can control the
      // default values for each.
      
      self.pool = UserDefaults.standard.value(forKey: Self.poolKey) as? Int ?? 5
      self.hunger = UserDefaults.standard.value(forKey: Self.hungerKey) as? Int ?? 1
      self.difficulty = UserDefaults.standard.value(forKey: Self.difficultyKey) as? Int ?? 3
    }
    
    /// Roll the dice!
    func roll() {
      diceBag = DiceBag(pool: pool, hunger: hunger, difficulty: difficulty)
    }
    
    /// Make a willpower re-roll.
    /// - Parameter method: The re-roll method to use.
    func reroll(strategy: DiceBag.RerollStrategy) {
      diceBag?.reroll(strategy: strategy)
    }
    
    // MARK: - UserDefaults Keys
    
    private static var poolKey: String {
      "PlainRollPoolKey"
    }
    
    private static var hungerKey: String {
      "PlainRollHungerKey"
    }
    
    private static var difficultyKey: String {
      "PlainRollDifficultyKey"
    }
    
  }
}
