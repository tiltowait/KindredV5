//
//  DiceRollView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI

struct DiceRollView: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @StateObject var viewModel: ViewModel
  
  init(kindred: Kindred) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          ButtonPad(columns: viewModel.attributeColumns, perform: viewModel.toggle)
          ButtonPad(columns: viewModel.skillColumns, perform: viewModel.toggle)
        }
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Close", action: dismiss)
        }
        
        ToolbarItem(placement: .primaryAction) {
          Button("Roll \(viewModel.pool) dice") {
            print("Rolling dice")
          }
        }
      }
      .navigationBarTitleDisplayMode(.inline)
    }
  }
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
  
}

#if DEBUG
struct DiceRollView_Previews: PreviewProvider {
    static var previews: some View {
      DiceRollView(kindred: Kindred.example)
    }
}
#endif
