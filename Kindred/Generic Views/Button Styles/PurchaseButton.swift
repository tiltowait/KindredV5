//
//  PurchaseButton.swift
//  Kindred
//
//  Created by Jared Lindsay on 9/3/21.
//

import SwiftUI

struct PurchaseButton: ButtonStyle {
  
  let highlight: Bool
  
  func makeBody(configuration: Configuration) -> some View {
    MyButton(configuration: configuration, highlight: highlight)
  }
  
  struct MyButton: View {
    @Environment(\.isEnabled)  private var isEnabled: Bool

    let configuration: ButtonStyleConfiguration
    let highlight: Bool
    
    var body: some View {
      configuration.label
        .font(.system(.body).bold())
        .padding(10)
        .background(highlight ? Color.green : Color.lightBlue) // Using blue instead of vampire red, because blue is common for purchases
        .clipShape(Capsule())
        .foregroundColor(.white)
        .opacity((configuration.isPressed || !isEnabled) ? 0.5 : 1)
    }
  }
    
}
