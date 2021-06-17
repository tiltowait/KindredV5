//
//  AddPowerSheet.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct AddPowerSheet: View {
  
  @StateObject private var viewModel: ViewModel
  @State private var selectedPower: Power?
  @State private var cardOpacity = 0.0
  
  init(discipline: Discipline, kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(discipline: discipline, kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    ZStack {
      List(viewModel.availablePowers) { power in
        PowerRow(power: power)
          .onTapGesture {
            selectedPower = power
            withAnimation {
              cardOpacity = 1
            }
          }
      }
      .navigationBarTitle(viewModel.title, displayMode: .inline)
      .listStyle(InsetGroupedListStyle())
      
      PowerCard(power: selectedPower, opacity: $cardOpacity, perform: addPower)
    }
  }
  
  func addPower(_ power: Power) {
    viewModel.add(power: power)
    
    // presentationMode.wrappedValue.dismiss() only pops back to
    // the AddDisciplineSheet, so we need to dip into UIKit to
    // completely dismiss the sheet
    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
  }
}

struct AddPowerSheet_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AddPowerSheet(discipline: Discipline.example, kindred: Kindred.example, dataController: DataController.preview)
    }
  }
}
