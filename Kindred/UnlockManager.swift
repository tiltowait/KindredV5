//
//  UnlockManager.swift
//  Kindred
//
//  Created by Jared Lindsay on 9/3/21.
//

import Combine
import StoreKit

class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
  
  enum RequestState {
    case loading
    case loaded([SKProduct])
    case failed(Error?)
    case purchased
    case deferred
  }
  
  private enum StoreError: Error {
    case invalidIdentifiers, missingProduct
  }
  
  @Published var requestState = RequestState.loading
  
  private let dataController: DataController
  private let request: SKProductsRequest
  private var loadedProducts: [SKProduct] = []
  
  /// Indicates whether the user is allowed to make payments.
  var canMakePayments: Bool {
    SKPaymentQueue.canMakePayments()
  }
  
  init(dataController: DataController) {
    self.dataController = dataController
    
    // Prepare to look for products
    let productIDs = Set([
      "com.tiltowait.Kindred.unlimited",
      "com.tiltowait.Kindred.camarilla",
      "com.tiltowait.Kindred.anarch",
      "com.tiltowait.Kindred.chicagoByNight",
      "com.tiltowait.Kindred.fallOfLondon",
      "com.tiltowait.Kindred.chicagoFolios",
      "com.tiltowait.Kindred.cults",
      "com.tiltowait.Kindred.childrenOfTheBlood",
      "com.tiltowait.Kindred.trailsOfAshAndBone"
    ])
    request = SKProductsRequest(productIdentifiers: productIDs)
    
    super.init()
    
    // Start watching the payment queue
    SKPaymentQueue.default().add(self)
    
    request.delegate = self
    request.start()
  }
  
  deinit {
    SKPaymentQueue.default().remove(self)
  }
  
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    DispatchQueue.main.async {
      for transaction in transactions {
        switch transaction.transactionState {
        case .purchased, .restored:
          self.dataController.purchase(identifier: transaction.payment.productIdentifier)
          self.requestState = .purchased
          queue.finishTransaction(transaction)
          
          if self.loadedProducts.isEmpty == false {
            self.requestState = .loaded(self.loadedProducts)
          }
          
        case .failed:
          if self.loadedProducts.isEmpty == false {
            self.requestState = .loaded(self.loadedProducts)
          } else {
            self.requestState = .failed(transaction.error)
          }
          queue.finishTransaction(transaction)
          
        case .deferred:
          self.requestState = .deferred
          
        default:
          break
        }
      }
    }
  }
  
  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    DispatchQueue.main.async {
      self.loadedProducts = response.products
      
      if self.loadedProducts.isEmpty {
        self.requestState = .failed(StoreError.missingProduct)
        return
      }
      
      if response.invalidProductIdentifiers.isEmpty == false {
        print("ALERT: Received invalid product identifiers: \(response.invalidProductIdentifiers)")
        self.requestState = .failed(StoreError.invalidIdentifiers)
        return
      }
      
      self.requestState = .loaded(self.loadedProducts)
    }
  }
  
  func buy(product: SKProduct) {
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }
  
  func restore() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
  func isPurchased(product: SKProduct) -> Bool {
    dataController.isPurchased(identifier: product.productIdentifier)
  }
  
}
