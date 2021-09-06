//
//  PurchaseButton.swift
//  Kindred
//
//  Created by Jared Lindsay on 9/3/21.
//

import SwiftUI

struct PurchaseButton: ButtonStyle {
  
  func makeBody(configuration: Configuration) -> some View {
    MyButton(configuration: configuration)
  }
  
  struct MyButton: View {
    let configuration: ButtonStyleConfiguration
    @Environment(\.isEnabled)  private var isEnabled: Bool
    
    var body: some View {
      configuration.label
        .font(.system(.body).bold())
        .padding(10)
        .background(Color.lightBlue) // Using blue instead of vampire red, because blue is common for purchases
        .clipShape(Capsule())
        .foregroundColor(.white)
        .opacity((configuration.isPressed || !isEnabled) ? 0.5 : 1)
    }
  }
    
}
