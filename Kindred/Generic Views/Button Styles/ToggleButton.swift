//
//  ToggleButton.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/17/21.
//

import SwiftUI

struct ToggleButton: ButtonStyle {
  
  @Binding var isToggled: Bool
  var color = Color.red
  
  func makeBody(configuration: Configuration) -> some View {
    ButtonProxy(configuration: configuration, isToggled: $isToggled, toggleColor: color)
  }
  
  struct ButtonProxy: View {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    let configuration: ButtonStyle.Configuration
    @Binding var isToggled: Bool
    let toggleColor: Color

    
    var backgroundColor: Color {
      isToggled ? toggleColor : .clear
    }
    
    var strokeColor: Color {
      isToggled ? toggleColor : .primary
    }
    
    var fontColor: Color {
      isToggled ? .white : .primary
    }
    
    var body: some View {
      configuration.label
        .frame(minHeight: 20)
        .padding(.vertical, 5)
        .autoscaling()
        .background(
          ZStack {
            RoundedRectangle(cornerRadius: 7)
              .strokeBorder(strokeColor, lineWidth: 2)
              .opacity(0.5)
            RoundedRectangle(cornerRadius: 7)
              .fill(backgroundColor)
          }
        )
        .foregroundColor(fontColor)
        .scaleEffect(configuration.isPressed ? 0.85 : 1)
        .opacity(isEnabled ? 1 : 0.5)
        .animation(
          .interactiveSpring(response: 0.15, dampingFraction: 0.4, blendDuration: 0.5),
          value: configuration.isPressed
        )
    }
    
    
  }
  
}
