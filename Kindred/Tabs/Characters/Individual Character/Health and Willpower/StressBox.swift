//
//  StressBox.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import SwiftUI

struct StressBox: View {
  
  enum Stress: Int, Comparable {
    case none
    case superficial
    case aggravated
    
    static func <(lhs: Stress, rhs: Stress) -> Bool {
      lhs.rawValue < rhs.rawValue
    }
  }
  
  static let size: CGFloat = 15
  
  static let bottomRight = CGPoint(x: 0, y: 0)
  static let topRight = CGPoint(x: size, y: 0)
  static let topLeft = CGPoint(x: size, y: size)
  static let bottomLeft = CGPoint(x: 0, y: size)
  
  let stress: Stress
  
  init(code: Character) {
    switch code {
    case "/":
      stress = .superficial
    case "x":
      stress = .aggravated
    default:
      stress = .none
    }
  }
  
  var body: some View {
    ZStack {
      Rectangle()
        .stroke(lineWidth: 2)
      
      Path { path in
        if stress == .aggravated {
          path.move(to: StressBox.bottomRight)
          path.addLine(to: StressBox.topLeft)
        }
        if stress >= .superficial {
          path.move(to: StressBox.bottomLeft)
          path.addLine(to: StressBox.topRight)
        }
      }
      .stroke(lineWidth: 2)
    }
    .frame(width: StressBox.size, height: StressBox.size)
  }
}

struct StressBox_Previews: PreviewProvider {
  static var previews: some View {
    HStack {
      StressBox(code: "x")
      StressBox(code: "/")
      StressBox(code: ".")
    }
  }
}
