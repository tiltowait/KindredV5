//
//  IconFooter.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/25/21.
//

import SwiftUI

struct IconFooter: View {
  
  let icon: String
  
  var body: some View {
    HStack {
      Spacer()
      
      Image(icon)
        .clipShape(Circle())
      
      Spacer()
    }
    .padding(.top)
  }
  
}

struct IconFooter_Previews: PreviewProvider {
  static var previews: some View {
    IconFooter(icon: Discipline.example.icon)
      .previewLayout(.sizeThatFits)
  }
}