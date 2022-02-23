//
//  BloodPotencyDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/9/21.
//

import SwiftUI

struct BloodPotencyDetail: View {
  
  let bloodPotency: BloodPotency
  
  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        detail("Blood Surge:", details: bloodPotency.surgeString)
          .padding(.bottom, 1)
        
        detail("Power Bonus", details: bloodPotency.powerBonusString)
          .padding(.bottom, 1)
        
        detail("Feeding Penalty:", details: bloodPotency.penalty)
      }
      
      VStack(alignment: .leading) {
        detail("Mend Amount:", details: bloodPotency.mendString)
          .padding(.bottom, 1)
        
        detail("Rouse Re-Roll", details: bloodPotency.rouseRerollString)
          .padding(.bottom, 1)
        
        detail("Bane Severity:", details: String(bloodPotency.baneSeverity))
      }
    }
    .font(.caption)
  }
  
  func detail(_ heading: String, details: String) -> some View {
    VStack(alignment: .leading) {
      Text(heading)
        .bold()
      Text(details)
        .lineLimitFix()
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel(Text("\(heading): \(details)"))
  }
}

struct BloodPotencyDetail_Previews: PreviewProvider {
  static var previews: some View {
    BloodPotencyDetail(bloodPotency: BloodPotency(3))
  }
}
