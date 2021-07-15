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
      diceLabel("pool", value: dice, color: .black)
    }
  }
  
  var hungerMenu: some View {
    MenuPicker(
      selected: $viewModel.hunger,
      array: viewModel.hungerRange
    ) { hunger in
      diceLabel("hung", value: hunger, color: .red)
    }
  }
  
  var difficultyMenu: some View {
    MenuPicker(selected: $viewModel.difficulty, array: viewModel.difficultyRange) { difficulty in
      diceLabel("diff", value: difficulty, color: .vampireRed)
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
      HStack(alignment: .top) {
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
        Text("Nothing rolled yet.")
          .foregroundColor(.secondary)
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
  
  func diceLabel(_ label: LocalizedStringKey, value: Int, color: Color) -> some View {
    VStack {
      Group {
        if value < 10 {
          HStack(spacing: 0) {
            Text("0")
              .opacity(0.15)
            Text("\(value)")
          }
          .font(bigFont)
        } else {
          Text("\(value)")
            .font(bigFont)
        }
      }
      .overlay(
        Rectangle()
          .frame(height: 5)
          .foregroundColor(color)
          .padding(.top, -15),
        alignment: .bottom
      )
      
      Text(label)
        .font(smallFont)
    }
  }
  
}

struct DiceRoller_Previews: PreviewProvider {
  static var previews: some View {
    DiceRoller()
  }
}
