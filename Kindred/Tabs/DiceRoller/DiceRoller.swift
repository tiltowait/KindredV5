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
        Text("\(dice)")
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
        Text("\(value)")
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
        Text("\(difficulty)")
          .font(bigFont)
          .underline()
        
        Text("diff")
          .font(smallFont)
      }
    }
  }
  
  var rollButton: some View {
    Button {
      // Roll
    } label: {
      HStack {
        Spacer()
        Label("Roll", systemImage: "diamond.fill")
          .font(.system(size: 30))
          .foregroundColor(.white)
        Spacer()
      }
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 15)
        .fill(Color.red)
    )
  }
  
  var body: some View {
    NavigationView {
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
      }
      .padding()
      .navigationBarTitle("Let's Roll", displayMode: .inline)
    }
  }
  
}

struct DiceRoller_Previews: PreviewProvider {
  static var previews: some View {
    DiceRoller()
  }
}
