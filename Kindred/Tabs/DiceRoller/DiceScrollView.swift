//
//  DiceScrollView.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/14/21.
//

import SwiftUI

struct DiceScrollView: View {
  
  let dice: [Int]
  let hunger: Bool
  
  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack {
        ForEach(dice.indices, id: \.self) { index in
          DieImage(die: dice[index], hunger: hunger)
        }
      }
    }
    .frame(height: 40)
  }
}

struct DiceScrollView_Previews: PreviewProvider {
    static var previews: some View {
        DiceScrollView(dice: [5,1,7,10], hunger: false)
    }
}
