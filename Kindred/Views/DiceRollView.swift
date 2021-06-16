//
//  DiceRollView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI

struct DiceRollView: View {
  
  @StateObject var viewModel: ViewModel
  
  init(kindred: Kindred) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          DicePad(columns: viewModel.attributeColumns, perform: viewModel.toggle)
          DicePad(columns: viewModel.skillColumns, perform: viewModel.toggle)
        }
      }
      .toolbar {
        Button("Roll \(viewModel.pool) dice") {
          print("Rolling dice")
        }
      }
      .navigationBarTitleDisplayMode(.inline)
    }
  }
  
}

//struct DiceRollView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiceRollView()
//    }
//}
