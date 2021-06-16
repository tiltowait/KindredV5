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
          + Text("\(bloodDrops)")
      } else {
        Text("Free use")
      }
    }
  }
  
  var bloodDrops: String {
    String(repeating: "🩸", count: Int(power.rouse))
  }
  
  var prerequisite: some View {
    Group {
      switch power.powerPrerequisite {
      case .amalgam(let amalgam):
        Text("Amalgam: ")
          .bold()
        + Text(amalgam)
      case .prerequisite(let prerequisite):
        Text("Prerequisite: ")
          .bold()
        + Text(prerequisite)
      case .none:
        EmptyView()
      }
    }
  }
  
  var durationText: some View {
    HStack(alignment: .top) {
      Text("Duration: ")
        .bold()
      Text(power.powerDuration)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      prerequisite
        .padding(.bottom, 5)
      
      Text(power.info)
        .italic()
      
      HStack(alignment: .top) {
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
          .padding(.top, 1)
      }
      
    }
  }
  
}

struct PowerInfoView_Previews: PreviewProvider {
  static var previews: some View {
    PowerInfoView(power: Power.example)
      .previewLayout(.sizeThatFits)
  }
}
