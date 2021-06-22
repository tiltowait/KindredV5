//
//  AdvantageView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import SwiftUI

struct AdvantageView: View {
  
  @StateObject var viewModel: ViewModel
  
  init(advantage: Advantage) {
    let viewModel = ViewModel(advantage: advantage)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    Form {
      PlainTextHeader(viewModel.advantage.info)
      
      if !viewModel.flaws.isEmpty {
        Section(header: Text("Flaws")) {
          ForEach(viewModel.flaws) { flaw in
            AdvantageOptionView(option: flaw)
          }
        }
      }
      if !viewModel.merits.isEmpty {
        Section(header: Text("Merits")) {
          ForEach(viewModel.merits) { merit in
            AdvantageOptionView(option: merit)
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
      AdvantageView(advantage: Advantage.fetchObject(named: "Bonding", in: context)!)
    }
  }
}
