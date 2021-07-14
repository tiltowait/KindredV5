//
//  DieView.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/14/21.
//

import SwiftUI

struct DieView: View {
  
  let imageName: String
  let tint: Color
  
  init(die: Int, hunger: Bool) {
    switch die {
    case 6...9:
      imageName = "SuccessDie"
    case 10:
      imageName = "CriticalDie"
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
    DieView(die: 5, hunger: false)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
    
    DieView(die: 7, hunger: false)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
    
    DieView(die: 10, hunger: false)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
    
    DieView(die: 5, hunger: true)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
    
    DieView(die: 7, hunger: true)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
    
    DieView(die: 10, hunger: true)
      .frame(height: 75)
      .previewLayout(.sizeThatFits)
  }
}
