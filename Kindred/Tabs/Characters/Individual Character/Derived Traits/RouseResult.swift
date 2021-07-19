//
//  RouseResult.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/19/21.
//

import SwiftUI

struct RouseResult: View, Identifiable {
  
  var id = UUID()
  
  @State private var scale: CGFloat = 0.8
  
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
    VStack(spacing: 20) {
      Text(title)
        .font(.title2)
        .bold()
      
      Image(systemName: imageName)
        .resizable()
        .scaledToFit()
        .frame(height: 80)
    }
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

struct Rouse_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black.edgesIgnoringSafeArea(.all).opacity(0.5)
      RouseResult(successful: true)
    }
  }
}
