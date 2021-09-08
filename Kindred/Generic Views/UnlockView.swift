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
  
  let highlights: [String]
  
  init(highlights: [String]) {
    self.highlights = highlights
  }
  
  var body: some View {
    NavigationView {
      List {
        Section(
          header:
            Text("If a previous purchase isn't showing up, then click 'Restore Purchases' below.")
            .font(.caption)
            .foregroundColor(.secondary),
          footer:
            Button("Restore Purchases", action: unlockManager.restore)
            .buttonStyle(PurchaseButton(highlight: false))
            .padding(.top)
            .centered()
        ) {
          switch unlockManager.requestState {
          case .loaded(let products):
            ForEach(products, id: \.self) { product in
              ProductView(product: product, highlight: self.highlights.contains(product.productIdentifier))
            }
          case .failed(_):
            Text("Sorry, there was an error loading the store. Please try again later.")
          case .loading:
            ProgressView("Loading")
          case .purchased:
            Text("Thank you!")
          case .deferred:
            Text("Thank you! Your request is pending approval, but you can keep using the app in the meantime.")
          }
        }
      }
      .listStyle(GroupedListStyle())
      .navigationBarTitle(Text("Unlocks"), displayMode: .inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: dismiss)
        }
        ToolbarItem(placement: .primaryAction) {
          Button {
            showingInfoAlert.toggle()
          } label: {
            Label("Information", systemImage: "info.circle")
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
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
}
