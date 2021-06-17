//
//  PowerCard.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct PowerCard: View {
  
  let power: Power
  @Binding var opacity: Double
  let perform: ((Power) -> Void)?
  
  init?(power: Power?, opacity: Binding<Double>, perform: ((Power) -> Void)? = nil) {
    guard let power = power else { return nil }
    
    self.power = power
    _opacity = opacity
    self.perform = perform
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
    ZStack {
      Color.black
        .ignoresSafeArea()
        .opacity(0.4)
      
      VStack {
        
        // The actual card
        ZStack {
          Color.systemBackground
          Image(power.discipline!.icon)
            .resizable()
            .scaledToFit()
            .padding()
            .padding()
            .opacity(0.1)
          
          VStack(spacing: 10) {
            // Title
            VStack(spacing: 5) {
              Text(power.name)
                .font(.system(size: 24, weight: .black, design: .serif))
              Text("Level \(power.level)")
                .font(Font.system(.subheadline).smallCaps())
                .foregroundColor(.secondary)
            }
//            .padding(.bottom, 10)

            
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
        .cornerRadius(20)
        .fixedSize(horizontal: false, vertical: true)
        .shadow(radius: 5)
        .padding()
        .padding()
        
        // Buttons
        HStack {
          Button {
            hide()
          } label: {
            ExitButton(40)
          }
          if let perform = perform {
            Button {
              perform(power)
            } label: {
              AddButton(40)
            }
          }
        }
      }
    }
    .opacity(opacity)
  }
  
  func hide() {
    withAnimation {
      opacity = 0
    }
  }
  
}

struct PowerCard_Previews: PreviewProvider {
  static var previews: some View {
    PowerCard(power: Power.example, opacity: .constant(1)) { _ in }
      .previewLayout(.sizeThatFits)
  }
}
