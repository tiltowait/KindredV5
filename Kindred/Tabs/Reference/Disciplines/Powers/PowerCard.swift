//
//  PowerCard.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct PowerCard: View {
  
  @Environment(\.viewController) var viewController
  
  let power: Power
  let action: ((Power) -> Void)?
  
  private let prerequisiteType: LocalizedStringKey
  private let prerequisite: String?
  
  init(power: Power, action: ((Power) -> Void)? = nil) {
    self.power = power
    self.action = action
    
    switch power.powerPrerequisite {
    case .amalgam(let amalgam):
      prerequisiteType = "Amalgam:"
      prerequisite = amalgam
    case .prerequisite(let prerequisite):
      prerequisiteType = "Prerequisite:"
      self.prerequisite = prerequisite
    case .none:
      prerequisiteType = ""
      prerequisite = nil
    }
  }
  
  /// The power's title, level, and source.
  var header: some View {
    VStack(spacing: 5) {
      Text(power.name)
        .font(.system(size: 24, weight: .black, design: .serif))
      Text("Level \(power.level)")
        .font(Font.system(.subheadline).smallCaps())
        .foregroundColor(.secondary)
      Text(power.pageReference)
        .font(.caption)
        .italic()
        .foregroundColor(.secondary)
    }
  }
  
  /// The power's rouse check in 🩸, or "Free".
  var rouse: String {
    let blood: String
    if power.rouse > 0 {
      blood = String(repeating: "🩸", count: Int(power.rouse))
    } else {
      blood = "Free"
    }
    return blood
  }
  
  /// The power's rouse cost and duration.
  var rouseAndDuration: some View {
    HStack {
      VStack(alignment: .leading, spacing: 7) {
        Text("Rouse: ")
          .bold()
        + Text(rouse)
        
        HStack(alignment: .top) {
          Text("Duration:")
            .bold()
          Text(power.powerDuration)
            .lineLimit(4)
        }
        .fixedSize(horizontal: false, vertical: true)
      }
      Spacer()
    }
  }
  
  /// The power's pool, if applicable.
  var pool: some View {
    Group {
      if let pool = power.pool {
        HStack(alignment: .top) {
          Text("Pool:")
            .bold()
          Text(pool)
          Spacer()
        }
      }
    }
  }
  
  /// Exit and (optionally) add buttons.
  var buttons: some View {
    HStack {
      Button(action: dismiss) {
        Image(systemName: "xmark")
      }
      .buttonStyle(PopUpImageButtonStyle())
      
      if let perform = action {
        Button("Add") {
         perform(power)
        }
        .buttonStyle(PopUpTextButtonStyle())
      }
    }
  }
  
  var body: some View {
    VStack {
      // The actual card
      ZStack {
        // Background image
        Image(power.discipline!.icon)
          .resizable()
          .scaledToFit()
          .padding()
          .padding()
          .opacity(0.1)
        
        // Card contents
        VStack(spacing: 10) {
          header
          Divider()
          
          if let prerequisite = prerequisite {
            HStack {
              BoldLabel(prerequisiteType, details: prerequisite)
              Spacer()
            }
          }
          Text(power.info)
            .italic()
          
          Divider()
          rouseAndDuration
          
          Spacer()
          pool
        }
        .padding()
      }
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(Color.systemBackground)
          .shadow(radius: 5)
      )
      .fixedSize(horizontal: false, vertical: true)
      .padding()
      .padding()
      
      buttons
    }
  }
  
  /// Dismiss the card.
  func dismiss() {
    viewController?.dismiss(animated: true)
  }
  
}

struct PowerCard_Previews: PreviewProvider {
  static var previews: some View {
    PowerCard(power: Power.example) { _ in }
      .previewLayout(.sizeThatFits)
  }
}
