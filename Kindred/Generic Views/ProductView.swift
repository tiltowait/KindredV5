//
//  ProductView.swift
//  Kindred
//
//  Created by Jared Lindsay on 9/3/21.
//

import SwiftUI
import StoreKit

struct ProductView: View {
  
  @EnvironmentObject var unlockManager: UnlockManager
  let product: SKProduct
  let highlight: Bool
  
  var buttonAccessibilityLabel: Text {
    if highlight {
      return Text("\(product.localizedTitle): \(product.localizedPrice), highlighted")
    } else if unlockManager.isPurchased(product: product) {
      return Text("\(product.localizedTitle): Already purchased")
    }
    return Text("\(product.localizedTitle): \(product.localizedPrice)")
  }
  
  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .leading) {
        Text(product.localizedTitle)
          .font(.headline)
        Text(product.localizedDescription)
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .accessibilityElement(children: .combine)
      .accessibilityLabel(Text("\(product.localizedTitle): \(product.localizedDescription)"))
      
      Spacer()
      
      Button(action: unlock) {
        if unlockManager.isPurchased(product: product) {
          ZStack {
            // Make the price invisible so that the buttons are all the same size
            Text("\(product.localizedPrice)")
              .accessibilityElement(children: .ignore)
              .hidden()
            
            Image(systemName: "checkmark")
              .font(.system(size: 18, weight: .bold, design: .default))
              .foregroundColor(.white)
          }
        } else {
          Text("\(product.localizedPrice)")
        }
      }
      .buttonStyle(PurchaseButton(highlight: highlight))
      .disabled(unlockManager.isPurchased(product: product))
      .accessibilityLabel(buttonAccessibilityLabel)
    }
  }
  
  func unlock() {
    unlockManager.buy(product: product)
  }
  
}
