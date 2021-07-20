//
//  RouseResult.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/19/21.
//

import SwiftUI

struct RouseResult: View {
  
  let title: String
  let imageName: String
  
  init(successful: Bool) {
    if successful {
      title = "Rouse Success"
      imageName = "drop.fill"
    } else {
      title = "Rouse Failure"
      imageName = "drop"
    }
  }
  
  var body: some View {
    Popover {
      VStack(spacing: 20) {
        Text(title)
          .font(.title2)
          .bold()
        
        Image(systemName: imageName)
          .resizable()
          .scaledToFit()
          .frame(height: 80)
      }
    }
  }
}

struct Rouse_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all).opacity(0.5)
      RouseResult(successful: true)
    }
  }
}
