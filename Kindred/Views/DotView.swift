//
//  DotView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

struct DotView: View {
  enum DotSize {
    case small
    case large
  }
  
  let size: CGFloat = 14
  let spacing: CGFloat = 5
  
  let rating: Int16
  let max: Int
  
  var body: some View {
    HStack(spacing: self.spacing) {
      Spacer()
      
      ForEach(1...max, id: \.self) { index in
        Circle()
          .fill(color(for: index))
          .frame(width: size, height: size)
        if index > 0 && index % 5 == 0 {
          Circle().fill(Color.clear)
            .frame(width: 1, height: 1)
        }
      }
      
      Spacer()
    }
  }
  
  func color(for rating: Int) -> Color {
    rating <= self.rating ? .vampireRed : .tertiarySystemGroupedBackground
  }
  
}

struct DotView_Previews: PreviewProvider {
  static var previews: some View {
    DotView(rating: 3, max: 15)
//      .previewLayout(.sizeThatFits)
  }
}
