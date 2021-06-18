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
  
  init(power: Power, action: ((Power) -> Void)? = nil) {
    self.power = power
    self.action = action
  }
  
  var rouse: String {
    let blood: String
    if power.rouse > 0 {
      blood = String(repeating: "🩸", count: Int(power.rouse))
    } else {
      blood = "Free"
    }
    return blood
  }
  
  var prerequisite: some View {
    HStack {
      Group {
        switch power.powerPrerequisite {
        case .amalgam(let amalgam):
          Text("Amalgam: ")
            .bold()
          + Text(amalgam)
        case .prerequisite(let prerequisite):
          Text("Prerequisite: ")
            .bold()
          + Text(prerequisite)
        case .none:
          EmptyView()
        }
      }
      Spacer()
    }
  }
  
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
            .lineLimit(2)
        }
        .fixedSize(horizontal: false, vertical: true)
      }
      Spacer()
    }
  }
  
  var body: some View {
    VStack {
      // The actual card
      ZStack {
        Image(power.discipline!.icon)
          .resizable()
          .scaledToFit()
          .padding()
          .padding()
          .opacity(0.1)
        
        VStack(spacing: 10) {
          // Title, level, and source
          VStack(spacing: 5) {
            Text(power.name)
              .font(.system(size: 24, weight: .black, design: .serif))
            Text("Level \(power.level)")
              .font(Font.system(.subheadline).smallCaps())
              .foregroundColor(.secondary)
            Text(power.sourceBook.reference(page: power.page))
              .font(.caption)
              .italic()
              .foregroundColor(.secondary)
          }
          
          Divider()
          prerequisite
          
          Text(power.info)
            .italic()
          
          Divider()
          rouseAndDuration
          
          // Pool
          if let pool = power.pool {
            HStack(alignment: .top) {
              Text("Pool:")
                .bold()
              Text(pool)
              Spacer()
            }
          }
        }
        .padding()
      }
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(Color.systemBackground)
          .shadow(radius: 5)
      )
      .fixedSize(horizontal: false, vertical: false)
      .padding()
      .padding()
      
      // Buttons
      HStack {
        Button(action: dismiss) {
          ExitButton(40)
        }
        if let perform = action {
          Button {
            perform(power)
          } label: {
            AddButton(40)
          }
        }
      }
    }
  }
  
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
