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
  
  var buttonLabel: Text {
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
      
      Button("\(product.localizedPrice)", action: unlock)
        .buttonStyle(PurchaseButton(highlight: highlight))
        .disabled(unlockManager.isPurchased(product: product))
        .accessibilityLabel(buttonLabel)
    }
  }
  
  func unlock() {
    unlockManager.buy(product: product)
  }
  
}
