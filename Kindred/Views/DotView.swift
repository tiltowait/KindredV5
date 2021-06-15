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
  
  let size: CGFloat = 17
  let spacing: CGFloat = 5
  
  let rating: Int
  let max: Int
  
  var body: some View {
    HStack(spacing: self.spacing) {
      ForEach(1...max, id: \.self) { index in
        Circle()
          .fill(color(for: index))
          .frame(width: size, height: size)
      }
    }
  }
  
  func color(for rating: Int) -> Color {
    rating <= self.rating ? .red : .gray
  }
  
}

struct DotView_Previews: PreviewProvider {
  static var previews: some View {
    DotView(rating: 3, max: 5)
      .previewLayout(.sizeThatFits)
  }
}
