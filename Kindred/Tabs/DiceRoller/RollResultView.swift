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
    VStack(spacing: 0) {
      HStack(spacing: 20) {
        Text("\(diceBag.totalSuccesses)")
          .font(.system(size: 100, weight: .black, design: .monospaced))
          .foregroundColor(successTint)
        VStack {
          DiceScrollView(dice: diceBag.normalDice, hunger: false)
          DiceScrollView(dice: diceBag.hungerDice, hunger: true)
        }
      }
      .padding(.leading)
      .padding(.leading)
      
      Text(diceBag.result.rawValue)
        .foregroundColor(resultTint)
        .font(.system(size: 60, weight: .bold))
        .padding(.horizontal)
        .minimumScaleFactor(0.0001)
        .lineLimit(1)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(Color.tertiarySystemGroupedBackground)
        .shadow(radius: 5)
    )
  }
}

struct RollResultView_Previews: PreviewProvider {
  static var previews: some View {
    RollResultView(diceBag: DiceBag(pool: 5, hunger: 1, difficulty: 3))
      .previewLayout(.sizeThatFits)
  }
}
