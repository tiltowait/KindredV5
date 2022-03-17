//
//  PowerCard.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct ReferenceCard<T: ReferenceItem, Content: View>: View {
  
  @Environment(\.viewController) var viewController
  
  let item: T
  let icon: String?
  let contents: () -> Content
  let addAction: ((T) -> Void)?
  
  init(
    item: T,
    icon: String?,
    @ViewBuilder contents: @escaping () -> Content,
    addAction: ((T) -> Void)?
  ) {
    self.item = item
    self.icon = icon
    self.contents = contents
    self.addAction = addAction
  }
  
  /// Exit and (optionally) add buttons.
  var buttons: some View {
    HStack {
      Button(action: dismiss) {
        Image(systemName: "xmark")
      }
      .buttonStyle(PopUpImageButtonStyle())
      .accessibilityLabel("Close popover")
      
      if let perform = addAction {
        Button("Add") {
         perform(item)
        }
        .buttonStyle(PopUpTextButtonStyle())
        .accessibilityLabel("Add to character")
      }
    }
  }
  
  var body: some View {
    GeometryReader { geo in
      VStack {
        // The actual card
          ZStack {
            // Background image
            if let icon = icon {
              Image(icon)
                .resizable()
                .scaledToFit()
                .padding()
                .padding()
                .opacity(0.1)
                .accessibilityHidden(true)
            }
            
            // Card contents
            VStack(spacing: 10) {
              contents()
            }
            .padding()
          }
          .background(
            RoundedRectangle(cornerRadius: 20)
              .fill(Color.systemBackground)
              .shadow(radius: 5)
          )
          .frame(maxWidth: 327, maxHeight: geo.size.height * 0.75)
          .fixedSize(horizontal: false, vertical: true)
          .padding()
          .padding()
        
        Spacer()
        
        buttons
          .padding(.bottom)
          .padding(.bottom)
          .padding(.bottom)
      }
    }
  }
  
  /// Dismiss the card.
  func dismiss() {
    viewController?.dismiss(animated: true)
  }
  
}

#if DEBUG
struct ReferenceCard_Previews: PreviewProvider {
  static var previews: some View {
    PowerCard(power: Power.example) { _ in }
//      .previewLayout(.sizeThatFits)
  }
}
#endif
