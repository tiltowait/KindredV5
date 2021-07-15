//
//  DiceRoller.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/13/21.
//

import SwiftUI

struct DiceRoller: View {
  
  @StateObject var viewModel = ViewModel()
  @State private var rolling = false
  
  let bigFont = Font.system(size: 700, weight: .black, design: .monospaced)
  let smallFont = Font.system(size: 200, design: .monospaced)
  
  var poolMenu: some View {
    MenuPicker(
      selected: $viewModel.pool,
      array: viewModel.poolRange
    ) { dice in
      VStack {
        Text(String(format: "%02d", dice))
          .font(bigFont)
          .underline()
        
        Text("pool")
          .font(smallFont)
      }
    }
  }
  
  var hungerMenu: some View {
    MenuPicker(
      selected: $viewModel.hunger,
      array: viewModel.hungerRange
    ) { hunger in
      VStack {
        Text(String(format: "%02d", hunger))
          .font(bigFont)
          .underline()
        
        Text("hung")
          .font(smallFont)
      }
    }
  }
  
  var difficultyMenu: some View {
    MenuPicker(selected: $viewModel.difficulty, array: viewModel.difficultyRange) { difficulty in
      VStack {
        Text(String(format: "%02d", difficulty))
          .font(bigFont)
          .underline()
        
        Text("diff")
          .font(smallFont)
      }
    }
  }
  
  var rollButton: some View {
    Button(action: roll) {
      HStack {
        Spacer()
        Label("Roll", systemImage: "diamond.fill")
          .font(.system(size: 30, weight: .black))
        Spacer()
      }
    }
    .buttonStyle(BoldButton(cornerRadius: 15, color: .red))
    .disabled(rolling)
  }
  
  var rerollButtons: some View {
    HStack {
      Button("Failures") {
        reroll(strategy: .rerollFailures)
      }
      .buttonStyle(BoldButton(color: .blue))
      .disabled(!viewModel.allowRerollingFailures || rolling)
      
      Button("Criticals") {
        reroll(strategy: .maximizeCriticals)
      }
      .buttonStyle(BoldButton(color: .blue))
      .disabled(!viewModel.allowMaximizingCriticals || rolling)
      
      Button("Messy") {
        reroll(strategy: .avoidMessyCritical)
      }
      .buttonStyle(BoldButton(color: .blue))
      .disabled(!viewModel.allowAvoidingMessyCriticals || rolling)
    }
  }
  
  var body: some View {
    VStack(spacing: 15) {
      // Menus
      HStack(alignment: .bottom) {
        poolMenu
          .accentColor(.primary)
        hungerMenu
          .accentColor(.red)
        difficultyMenu
          .accentColor(.vampireRed)
      }
      .minimumScaleFactor(0.0001)
      .lineLimit(1)
      
      rollButton
      
      if let diceBag = viewModel.diceBag {
        RollResultView(diceBag: diceBag)
          .padding(.vertical)
      } else {
        Spacer()
      }
      
      Text("Re-roll Strategy")
        .font(.title2.smallCaps())
      rerollButtons
    }
    .padding()
  }
  
  func roll() {
    performOperation(count: 5, operation: viewModel.roll)
  }
  
  func reroll(strategy: DiceBag.RerollStrategy) {
    performOperation(count: 5) {
      viewModel.reroll(strategy: strategy)
    }
  }
  
  /// Perform an operation a specified number of times.
  ///
  /// The buttons are disabled for the duration.
  ///
  /// This method has to be in the view, not the view model, because
  /// of the button state animations.
  /// - Parameters:
  ///   - count: The number of times to perform the operation.
  ///   - operation: The
  private func performOperation(
    count: Int,
    operation: @escaping () -> ()
  ) {
    var phonyRolls = 0
    
    withAnimation(.easeInOut(duration: 0.1)) {
      rolling = true
    }
    
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
      operation()
      phonyRolls += 1
      
      if phonyRolls == count {
        timer.invalidate()
        
        withAnimation(.easeInOut(duration: 0.1)) {
          rolling = false
        }
      }
    }
  }
  
}

struct DiceRoller_Previews: PreviewProvider {
  static var previews: some View {
    DiceRoller()
  }
}
