//
//  PowerInfoView.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import SwiftUI

struct PowerInfoView: View {
  
  let power: Power
  
  var rouseText: some View {
    Group {
      if power.rouse > 0 {
        Text("Rouse: ")
          .bold()
          + Text("\(power.rouse)")
      } else {
        Text("Free use")
      }
    }
  }
  
  var durationText: some View {
    Text("Duration: ")
      .bold()
      + Text(power.powerDuration)
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(power.powerInfo)
        .italic()
      HStack {
        rouseText
          .font(.callout)
        Spacer()
        durationText
          .font(.callout)
      }
      .padding(.top, 5)
      
      if let pool = power.pool {
        Text(pool)
          .bold()
          .italic()
          .font(.callout)
      }
      
    }
  }
  
}

struct PowerInfoView_Previews: PreviewProvider {
  static var previews: some View {
    PowerInfoView(power: Global.tdController.disciplines.first!.allPowers.randomElement()!)
      .previewLayout(.sizeThatFits)
  }
}
