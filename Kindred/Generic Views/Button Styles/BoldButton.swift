//
//  BoldButton.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/14/21.
//

import SwiftUI

struct BoldButton: ButtonStyle {
  
  var cornerRadius: CGFloat = 10
  let color: Color
  
  func makeBody(configuration: Configuration) -> some View {
    ButtonProxy(configuration: configuration, cornerRadius: cornerRadius, color: color)
  }
  
  struct ButtonProxy: View {
    @Environment(\.isEnabled) private var isEnabled: Bool

    let configuration: ButtonStyle.Configuration
    let cornerRadius: CGFloat
    let color: Color
    
    var body: some View {
      configuration.label
        .font(.body.weight(.black))
        .padding()
        .frame(maxWidth: .infinity)
        .background(
          RoundedRectangle(cornerRadius: cornerRadius)
            .fill(color)
        )
        .foregroundColor(.white)
        .scaleEffect(configuration.isPressed ? 0.85 : 1)
        .opacity(isEnabled ? 1 : 0.5)
        .animation(
          .interactiveSpring(response: 0.15, dampingFraction: 0.4, blendDuration: 0.5),
          value: configuration.isPressed
        )
    }
    
  }
  
}

struct BoldButton_Previews: PreviewProvider {
  static var previews: some View {
    Button("Test") { }
      .padding()
      .buttonStyle(BoldButton(color: .red))
  }
}
