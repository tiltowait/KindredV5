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
      Text(diceBag.result.rawValue)
        .multilineTextAlignment(.center)
        .font(.system(size: 60, weight: .heavy))
        .foregroundColor(resultTint)
      
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
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .strokeBorder(
          successTint,
          style: StrokeStyle(
            lineWidth: 4,
            dash: [15]
          )
        )
        .opacity(0.5)
    )
  }
}

struct RollResultView_Previews: PreviewProvider {
  static var previews: some View {
    RollResultView(diceBag: DiceBag(pool: 5, hunger: 1, difficulty: 3))
      .previewLayout(.sizeThatFits)
  }
}
