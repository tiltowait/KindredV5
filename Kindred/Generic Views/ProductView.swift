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
  
  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .leading) {
        Text(product.localizedTitle)
          .font(.headline)
        Text(product.localizedDescription)
          .font(.caption)
          .foregroundColor(.secondary)
      }
      Spacer()
      
      Button("\(product.localizedPrice)", action: unlock)
        .buttonStyle(PurchaseButton(highlight: highlight))
        .disabled(unlockManager.isPurchased(product: product))
    }
  }
  
  func unlock() {
    unlockManager.buy(product: product)
  }
  
}
