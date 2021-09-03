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
  
  var body: some View {
    HStack(alignment: .center) {
      VStack(alignment: .leading) {
        Text(product.localizedTitle)
          .font(.headline)
        Text(product.localizedDescription)
          .font(.caption)
          .foregroundColor(.secondary)
      }
      Button("\(product.localizedPrice)", action: unlock)
        .buttonStyle(PurchaseButton())
    }
  }
  
  func unlock() {
    unlockManager.buy(product: product)
  }
  
}
