//
//  AdvantageOptionMarker.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import SwiftUI

struct AdvantageOptionMarker: View {
  
  let count: Int
  let square: Bool
  
  var shape: some View {
    Group {
      if square {
        Rectangle()
          .fill(Color.black)
          .frame(width: 8, height: 8)
      } else {
        Circle()
          .fill(Color.black)
          .frame(width: 6, height: 6)
      }
    }
  }
  
  var body: some View {
    HStack {
      ForEach(0..<count) { _ in
        shape
      }
    }
  }
}

struct AdvantageOptionMarker_Previews: PreviewProvider {
  static var previews: some View {
    AdvantageOptionMarker(count: 2, square: true)
  }
}
