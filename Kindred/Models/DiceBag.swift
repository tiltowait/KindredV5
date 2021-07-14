//
//  DiceBag.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/14/21.
//

import Foundation

struct DiceBag {
  
  enum RollResult: String {
    case critical = "Critical"
    case messyCritical = "Messy Critical"
    case success = "Success"
    case failure = "Failure"
    case totalFailure = "Total Failure"
    case bestialFailure = "Bestial Failure"
  }
  
  enum RerollMethod: String {
    case rerollFailures = "Re-roll Failures"
    case maximizeCriticals = "Maximize Criticals"
    case avoidMessyCritical = "Avoid Messy Critical"
  }
  
  /// The total size of the dice pool, including hunger dice.
  let pool: Int
  
  /// The user's current hunger rating.
  let hunger: Int
  
  /// The target number of successes.
  let difficulty: Int
  
  /// The non-hunger dice that were rolled.
  var normalDice: [Int]
  
  /// The hunger dice that were rolled.
  let hungerDice: [Int]
  
  /// The result of the roll.
  var result: RollResult = .totalFailure
  
  var totalSuccesses = 0
  
  /// The willpower re-roll methods available for this roll.
  var rerollOptions: [RerollMethod] = []
  
  init(pool: Int, hunger: Int, difficulty: Int) {
    // Technically, pool and difficulty must both be positive and hunger must be
    // between 1 and 5. However, the UI does not allow invalid arguments, so we
    // can forego checks.
  
    self.pool = pool
    self.hunger = hunger
    self.difficulty = difficulty
    
    let normalPool = (pool - hunger).clamp(low: 0, high: pool)
    let hungerPool = hunger.clamp(low: 0, high: pool)
    
    self.normalDice = (0..<normalPool).map { _ in Int.random(in: 1...10) }
    self.hungerDice = (0..<hungerPool).map { _ in Int.random(in: 1...10) }
    
    (self.totalSuccesses, self.result) = self.calculateResults()
    self.rerollOptions = getRerollOptions()
  }
  
  mutating func reroll(method rerollMethod: RerollMethod) {
    // A willpower reroll lets us reroll up to 3 non-hunger dice.
    switch rerollMethod {
    case .rerollFailures:
      normalDice = rerollThree(below: 6)
    case .maximizeCriticals:
      normalDice = rerollThree(below: 10)
    case .avoidMessyCritical:
      normalDice = avoidMessyCritical()
    }
    (self.totalSuccesses, self.result) = self.calculateResults()
    self.rerollOptions = getRerollOptions()
  }
  
  private func rerollThree(below target: Int) -> [Int] {
    var sortedDice = normalDice.sorted(by: <)
    var rerolledDice: [Int] = []
    
    for _ in 1...3 {
      if let die = sortedDice.first {
        if die < target {
          sortedDice.removeFirst()
          rerolledDice.append(Int.random(in: 1...10))
        } else {
          break
        }
      } else {
        break
      }
    }
    return (sortedDice + rerolledDice).shuffled()
  }
  
  /// Reroll up to three normal 10s.
  private func avoidMessyCritical() -> [Int] {
    var sortedDice = normalDice.sorted(by: >)
    var rerolledDice: [Int] = []
    
    for _ in 1...3 {
      if let die = sortedDice.first {
        if die == 10 {
          sortedDice.removeFirst()
          rerolledDice.append(Int.random(in: 1...10))
        } else {
          break
        }
      } else {
        break
      }
    }
    return (sortedDice + rerolledDice).shuffled()
  }
  
  private func calculateResults() -> (successes: Int, result: RollResult) {
    // Rules:
    // - Everything 6+ is a success
    // - Double 10s make a critical (4 successes total)
    // - If one of those tens is a hunger die, it is a messy critical
    // - If the difficulty isn't met, the roll is a failure
    // - If no successes are rolled, it is a total failure
    // - If the difficulty isn't met, and there is at least one 1 on a hunger die,
    //     it is a bestial failure.
    
    // While it would be more efficient to manually go through the arrays
    // than to repeatedly filter and count, the arrays are so small that
    // this more concise method is preferable.
    
    let normalSuccesses = normalDice.filter { 6...9 ~= $0 }.count
    let normalTens = normalDice.filter { $0 == 10 }.count
    let hungerSuccesses = hungerDice.filter { 6...9 ~= $0 }.count
    let hungerTens = hungerDice.filter { $0 == 10 }.count
    
    let totalNonTenSuccesses = normalSuccesses + hungerSuccesses
    let totalTens = normalTens + hungerTens
    
    let criticals = totalTens / 2
    let remainingTens = totalTens % 2
    let totalSuccesses = totalNonTenSuccesses + (criticals * 2) + remainingTens
    
    let result: RollResult
    
    if totalSuccesses == 0 {
      result = .totalFailure
    } else if totalSuccesses < difficulty {
      if hungerDice.contains(1) {
        result = .bestialFailure
      } else {
        result = .failure
      }
    } else {
      if criticals > 0 {
        if hungerTens > 0 {
          result = .messyCritical
        } else {
          result = .critical
        }
      } else {
        result = .success
      }
    }
    return (totalSuccesses, result)
  }
  
  func getRerollOptions() -> [RerollMethod] {
    var options: [RerollMethod] = []
    
    let hasFailures = !normalDice.filter { $0 < 6 }.isEmpty
    if hasFailures {
      options.append(.rerollFailures)
    }
    
    let normalTens = normalDice.filter { $0 == 10 }.count
    if normalTens < normalDice.count {
      options.append(.maximizeCriticals)
    }
    
    let hungerTens = hungerDice.filter { $0 == 10 }.count
    if hungerTens == 1 && normalTens < normalDice.count {
      options.append(.avoidMessyCritical)
    }
    
    return options
  }
  
}
