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
        Text("Blood Surge:")
          .bold()
        Text(bloodPotency.surgeString)
          .padding(.bottom, 1)
        
        Text("Power Bonus:")
          .bold()
        Text(bloodPotency.powerBonusString)
          .padding(.bottom, 1)
        
        Text("Feeding Penalty:")
          .bold()
        Text(bloodPotency.penalty)
      }
      
      VStack(alignment: .leading) {
        Text("Mend Amount:")
          .bold()
        Text(bloodPotency.mendString)
          .padding(.bottom, 1)
        
        Text("Rouse Re-Roll:")
          .bold()
        Text(bloodPotency.rouseRerollString)
          .padding(.bottom, 1)
        
        Text("Bane Severity:")
          .bold()
        Text(String(bloodPotency.baneSeverity))
      }
    }
    .font(.caption)
  }
}

struct BloodPotencyDetail_Previews: PreviewProvider {
  static var previews: some View {
    BloodPotencyDetail(bloodPotency: BloodPotency(3))
  }
}
