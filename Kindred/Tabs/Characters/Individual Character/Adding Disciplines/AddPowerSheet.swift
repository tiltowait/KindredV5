//
//  AddPowerSheet.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct AddPowerSheet: View {
  
  @Environment(\.viewController) var viewController
  
  @StateObject private var viewModel: ViewModel
  
  init(discipline: Discipline, kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(discipline: discipline, kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List(viewModel.availablePowers) { power in
      Button {
        show(power: power)
      } label: {
        PowerRow(power: power)
      }
      .buttonStyle(PlainButtonStyle())
    }
    .navigationBarTitle(viewModel.title, displayMode: .inline)
    .listStyle(InsetGroupedListStyle())
  }
  
  /// Modally display a power's details.
  /// - Parameter power: The power to display.
  func show(power: Power) {
    viewController?.present {
      PowerCard(power: power, action: addPower)
    }
  }
  
  /// Add a power to the view controller's referenced character.
  /// - Parameter power: The power to add.
  func addPower(_ power: Power) {
    viewModel.add(power: power)
    
    // presentationMode.wrappedValue.dismiss() only pops back to
    // the AddDisciplineSheet, so we need to dip into UIKit to
    // completely dismiss the sheet
    UIViewController.root?.dismiss(animated: true)
  }
}

struct AddPowerSheet_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AddPowerSheet(discipline: Discipline.example, kindred: Kindred.example, dataController: DataController.preview)
    }
  }
}
