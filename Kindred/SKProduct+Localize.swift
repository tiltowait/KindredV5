//
//  SKProduct+Localize.swift
//  Kindred
//
//  Created by Jared Lindsay on 9/3/21.
//

import StoreKit

extension SKProduct {
  
  var localizedPrice: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = priceLocale
    return formatter.string(from: price)!
  }
  
}
