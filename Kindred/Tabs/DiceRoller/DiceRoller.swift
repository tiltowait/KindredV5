//
//  DiceRoller.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/13/21.
//

import SwiftUI

struct DiceRoller: View {
  
  @StateObject var viewModel = ViewModel()
  
  let bigFont = Font.system(size: 700, weight: .black, design: .monospaced)
  let smallFont = Font.system(size: 200, design: .monospaced)
  
  var diceMenu: some View {
    MenuPicker(
      selected: $viewModel.pool,
      array: viewModel.poolRange
    ) { dice in
      VStack {
        Text(String(format: "%02d", dice - 1))
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
    ) { value in
      VStack {
        Text(String(format: "%02d", value))
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
        Text(String(format: "%02d", difficulty - 1))
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
  }
  
  var rerollButtons: some View {
    HStack {
      Button("Failures") {
        reroll(method: .rerollFailures)
      }
      .buttonStyle(BoldButton(color: .blue))
      .disabled(!viewModel.allowRerollingFailures)
      
      Button("Criticals") {
        reroll(method: .maximizeCriticals)
      }
      .buttonStyle(BoldButton(color: .blue))
      .disabled(!viewModel.allowMaximizingCriticals)
      
      Button("Messy") {
        reroll(method: .avoidMessyCritical)
      }
      .buttonStyle(BoldButton(color: .blue))
      .disabled(!viewModel.allowAvoidingMessyCriticals)
    }
  }
  
  var body: some View {
      VStack {
        HStack(alignment: .bottom) {
          diceMenu
            .accentColor(.primary)
          hungerMenu
            .accentColor(.red)
          difficultyMenu
            .accentColor(.vampireRed)
        }
        .minimumScaleFactor(0.0001)
        .lineLimit(1)
        
        rollButton
          .padding(.top)
        
        Spacer()
        
        if let diceBag = viewModel.diceBag {
          RollResultView(diceBag: diceBag)
          Spacer()
        }
        
        rerollButtons
      }
      .padding()
  }
  
  func roll() {
    viewModel.roll()
  }
  
  func reroll(method: DiceBag.RerollMethod) {
    viewModel.reroll(method: method)
  }
  
}

struct DiceRoller_Previews: PreviewProvider {
  static var previews: some View {
    DiceRoller()
  }
}
