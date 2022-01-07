//
//  DieImage.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/14/21.
//

import SwiftUI

/// An resizable image representing a die result.
struct DieImage: View {
  
  let imageName: String
  let tint: Color
  
  init(die: Int, hunger: Bool) {
    switch die {
    case 6...9:
      imageName = "SuccessDie"
    case 10:
      imageName = hunger ? "MessyDie" : "CriticalDie"
    default:
      imageName = "FailureDie"
    }
    tint = hunger ? .red : .primary
  }
  
  var body: some View {
    Image(imageName)
      .resizable()
      .renderingMode(.template)
      .foregroundColor(tint)
      .scaledToFit()
  }
}

struct DieView_Previews: PreviewProvider {
  static var previews: some View {
    DieImage(die: 5, hunger: false)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
    
    DieImage(die: 7, hunger: false)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
    
    DieImage(die: 10, hunger: false)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
    
    DieImage(die: 5, hunger: true)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
    
    DieImage(die: 7, hunger: true)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
    
    DieImage(die: 10, hunger: true)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
  }
}
