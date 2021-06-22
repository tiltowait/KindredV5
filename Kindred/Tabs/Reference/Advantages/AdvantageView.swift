//
//  AdvantageView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import SwiftUI

struct AdvantageView: View {
  
  @StateObject var viewModel: ViewModel
  
  init(advantage: Advantage, kindred: Kindred?, dataController: DataController?) {
    let viewModel = ViewModel(advantage: advantage, kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    Form {
      PlainTextHeader(viewModel.advantage.info)
      
      if !viewModel.flaws.isEmpty {
        Section(header: Text("Flaws")) {
          ForEach(viewModel.flaws) { flaw in
            AdvantageOptionView(option: flaw, kindred: viewModel.kindred, dataController: viewModel.dataController)
          }
        }
      }
      if !viewModel.merits.isEmpty {
        Section(header: Text("Merits")) {
          ForEach(viewModel.merits) { merit in
            AdvantageOptionView(option: merit, kindred: viewModel.kindred, dataController: viewModel.dataController)
          }
        }
      }
    }
    .navigationBarTitle(viewModel.title, displayMode: .inline)
  }
  
}

struct AdvantageView_Previews: PreviewProvider {
  
  static let context = DataController.preview.container.viewContext
  
  static var previews: some View {
    NavigationView {
      AdvantageView(advantage: Advantage.fetchObject(named: "Bonding", in: context)!, kindred: nil, dataController: nil)
    }
  }
}
