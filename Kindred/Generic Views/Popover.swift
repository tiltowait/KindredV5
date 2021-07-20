//
//  RouseResult.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/19/21.
//

import SwiftUI

struct Popover<Content: View>: View, Identifiable {
  
  var id = UUID()
  
  @State private var scale: CGFloat = 0.8
  
  let contents: () -> Content
  
  var body: some View {
    contents()
      .foregroundColor(.secondary)
      .padding()
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(Color.tertiarySystemGroupedBackground)
          .shadow(radius: 10)
      )
      .scaleEffect(scale)
      .onAppear {
        withAnimation(
          .spring(
            response: 0.3,
            dampingFraction: 0.5,
            blendDuration: 0.5
          )
        ) {
          scale = 1
        }
      }
  }
}

struct Popover_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all).opacity(0.5)
      Popover {
        VStack(spacing: 10) {
          Text("Hi")
            .font(.title)
          Text("No way is this good")
        }
      }
    }
  }
}
