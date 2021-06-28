//
//  SwapView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/28/21.
//

import SwiftUI

struct SwapView<Left: View, Right: View>: View {
  
  let showingLeft: Bool
  let left: () -> Left
  let right: () -> Right
  
  let height: CGFloat
  let transition: AnyTransition
  
  init(
    showingLeft: Bool,
    height: CGFloat = 200,
    @ViewBuilder left: @escaping () -> Left,
    @ViewBuilder right: @escaping () -> Right
  ) {
    self.showingLeft = showingLeft
    self.left = left
    self.right = right
    self.height = height
    
    transition = .move(edge: showingLeft ? .leading : .trailing).combined(with: .opacity)
  }
  
  var body: some View {
    ZStack(alignment: .center) {
      VStack {
        if showingLeft {
          left()
            .transition(transition)
            .animation(.spring())
        }
      }
      VStack {
        if !showingLeft {
          right()
            .transition(transition)
            .animation(.spring())
        }
      }
    }
    .frame(height: height)
  }
  
}
