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
  
  private let amalgams: String?
  private let prerequisites: String?
  
  init(power: Power, action: ((Power) -> Void)? = nil) {
    self.power = power
    self.action = action
    
    self.amalgams = power.amalgams?.joined(separator: ", ")
    self.prerequisites = power.prerequisitePowers?.joined(separator: ", ")
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
        Text("**Rouse:** \(rouse)")
        
        HStack(alignment: .top) {
          Text("**Duration:** \(power.powerDuration)")
            .lineLimit(4)
        }
        .fixedSize(horizontal: false, vertical: true)
      }
      Spacer()
    }
  }
  
  /// The power's pool, if applicable.
  @ViewBuilder var pool: some View {
    if let pool = power.pool {
      HStack(alignment: .top) {
        Text("Pool:")
          .bold()
        Text(pool)
        Spacer()
      }
    }
  }
  
  var body: some View {
    ReferenceCard(
      item: power,
      icon: power.discipline?.icon,
      contents: {
        header
        Divider()
        
        if let prerequisites = prerequisites {
          HStack {
            BoldLabel("Prerequisite:", details: prerequisites)
            Spacer()
          }
        }
        if let amalgams = amalgams {
          HStack {
            BoldLabel("Amalgam:", details: amalgams)
            Spacer()
          }
        }
        ScrollView {
          Text(power.info)
            .italic()
        }
        
        Divider()
        rouseAndDuration
        
        Spacer()
        pool
      },
      addAction: action
    )
  }
  
  /// Dismiss the card.
  func dismiss() {
    viewController?.dismiss(animated: true)
  }
  
}

#if DEBUG
struct PowerCard_Previews: PreviewProvider {
  static var previews: some View {
    PowerCard(power: Power.example) { _ in }
      .previewLayout(.sizeThatFits)
  }
}
#endif
