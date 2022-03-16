//
//  UnlockView.swift
//  Kindred
//
//  Created by Jared Lindsay on 9/3/21.
//

import SwiftUI
import StoreKit

struct UnlockView: View {
  
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var unlockManager: UnlockManager
  
  @State private var showingInfoAlert = false
  
  let highlights: Set<String>
  
  init(highlights: [String]) {
    self.highlights = Set(highlights)
  }
  
  var body: some View {
    NavigationView {
      List {
        Section {
          switch unlockManager.requestState {
          case .loaded(let products):
            list(products: products)
          case .failed(_):
            Text("Sorry, there was an error loading the store. Please try again later.")
          case .loading:
            ProgressView("Loading")
          case .purchased:
            Text("Thank you!")
          case .deferred:
            Text("Thank you! Your request is pending approval, but you can keep using the app in the meantime.")
          }
        } header: {
          Text("If a previous purchase isn't showing up, then click 'Restore Purchases' below.")
            .font(.caption)
            .foregroundColor(.secondary)
        } footer: {
          Button("Restore Purchases", action: unlockManager.restore)
            .buttonStyle(PurchaseButton(highlight: false))
            .padding(.top)
            .centered()
        }
      }
      .listStyle(.grouped)
      .navigationBarTitle(Text("Unlocks"), displayMode: .inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: dismiss)
        }
        ToolbarItem(placement: .primaryAction) {
          Button {
            showingInfoAlert.toggle()
          } label: {
            Label("Purchases Information", systemImage: "info.circle")
          }
        }
      }
    }
    .onReceive(unlockManager.$requestState) { value in
      if case .purchased = value {
        dismiss()
      }
    }
    .alert(isPresented: $showingInfoAlert) {
      Alert(
        title: Text("In-App Purchases"),
        message: Text("The free version of Kindred grants access to reference material from the core rulebook and allows you to create a single character. To remove this restriction and unlock additional features, make a selection from the purchase options below. Thanks for your support!"),
        dismissButton: .default(Text("OK"))
      )
    }
  }
  
  /// Generate a list of products, with the highlighted product(s) at the top.
  /// - Parameter products: The products to show.
  /// - Returns: The generated list.
  func list(products: [SKProduct]) -> some View {
    var products = products
    var highlightedProducts: [SKProduct] = []
    
    for highlight in highlights {
      if let index = products.firstIndex(where: { highlight == $0.productIdentifier }) {
        highlightedProducts.append(products.remove(at: index))
      }
    }
    
    products = highlightedProducts + products
    
    return ForEach(products, id: \.self) { product in
      // This is fairly inefficient, but `highlights` will almost always be one item, and it will never be a long list
      ProductView(product: product, highlight: self.highlights.contains(product.productIdentifier))
    }
  }
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
}
