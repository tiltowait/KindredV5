//
//  LoadingIndicator.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/15/21.
//

import SwiftUI



struct LoadingIndicator: View {
  
  let label: LocalizedStringKey
  
  @State private var scale: CGFloat = 0.8
  
  init(_ label: LocalizedStringKey) {
    self.label = label
  }
  
  var body: some View {
    VStack(spacing: 30) {
      Text(label)
        .foregroundColor(.secondary)
        .font(.title3)
        .bold()
      
      DotIndicator()
    }
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

struct LoadingIndicator_Previews: PreviewProvider {
  static var previews: some View {
    LoadingIndicator("Exporting Character")
  }
}

// MARK: - Indicators

/// A spinning 3/4 circle.
fileprivate struct CircularIndicator: View {
  
  @State private var isLoading = false
  
  var body: some View {
    Circle()
      .trim(from: 0, to: 0.7)
      .stroke(Color.secondary, lineWidth: 10)
      .frame(width: 100, height: 100)
      .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
      .animation(
        .interpolatingSpring(
          mass: 1,
          stiffness: 1,
          damping: 0.1,
          initialVelocity: 2
        )
        .repeatForever(autoreverses: true)
      )
      .onAppear {
        self.isLoading = true
      }
  }
  
}


/// Three pulsing dots.
fileprivate struct DotIndicator: View {
  
  struct LoadingDot: View {
    
    @State var delay: Double = 0
    @State var scale: CGFloat = 0.5
    
    var body: some View {
      Circle()
        .fill(Color.secondary)
        .frame(width: 25, height: 25)
        .scaleEffect(scale)
        .animation(.easeInOut(duration: 0.6).repeatForever().delay(delay))
        .onAppear {
          withAnimation {
            self.scale = 1
          }
        }
    }
  }
  
  var body: some View {
    HStack {
      LoadingDot()
      LoadingDot(delay: 0.2)
      LoadingDot(delay: 0.4)
    }
  }
  
}
