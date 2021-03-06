//
//  RollResultView.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/14/21.
//

import SwiftUI

struct RollResultView: View {
  
  let diceBag: DiceBag
  let resultTint: Color
  let successTint: Color
  
  init(diceBag: DiceBag) {
    self.diceBag = diceBag
    
    switch diceBag.result {
    case .critical:
      resultTint = .green
      successTint = .green
      
    case .messyCritical:
      resultTint = .red
      successTint = .primary
      
    case .success:
      resultTint = .green
      successTint = .green
      
    case .failure:
      resultTint = .vampireRed
      successTint = .vampireRed
      
    case .totalFailure:
      resultTint = .primary
      successTint = .primary
      
    case .bestialFailure:
      resultTint = .red
      successTint = .red
    }
  }
  
  var body: some View {
    VStack(spacing: 10) {
      HStack(spacing: 10) {
        Text("\(diceBag.totalSuccesses)")
          .font(.system(size: 90, weight: .black, design: .monospaced))
          .foregroundColor(successTint)
          .padding(.vertical, -15)
        VStack {
          if !diceBag.normalDice.isEmpty {
            DiceScrollView(dice: diceBag.normalDice, hunger: false)
          }
          if !diceBag.hungerDice.isEmpty {
            DiceScrollView(dice: diceBag.hungerDice, hunger: true)
          }
        }
      }
      .padding(.horizontal, 20)
      .padding(.leading)
      .padding(.leading)
      
      Text(diceBag.result.rawValue)
        .foregroundColor(resultTint)
        .font(.system(size: 35, weight: .bold))
        .padding(.horizontal)
    }
    .padding(.horizontal)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 15)
        .strokeBorder(Color.primary, lineWidth: 4)
    )
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(diceBag.result.rawValue): \(diceBag.totalSuccesses) success")

  }
}

struct RollResultView_Previews: PreviewProvider {
  static var previews: some View {
    RollResultView(diceBag: DiceBag(pool: 5, hunger: 1, difficulty: 3))
      .padding()
//      .previewLayout(.sizeThatFits)
  }
}
