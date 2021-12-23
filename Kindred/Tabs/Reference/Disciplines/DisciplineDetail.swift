//
//  DisciplineDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct DisciplineDetail: View {
  
  @EnvironmentObject var dataController: DataController
  @StateObject private var viewModel: ViewModel
  @Binding var link: Bool
  
  @State private var unlockItem: String?
  
  init(discipline: Discipline, kindred: Kindred?, link: Binding<Bool>? = nil) {
    let viewModel = ViewModel(discipline: discipline, kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
    _link = link ?? .constant(false)
  }
  
  var body: some View {
    List {
      Section {
        ForEach(viewModel.availablePowers) { power in
          Button {
            show(power: power)
          } label: {
            PowerRow(
              power: power,
              isUnlocked: dataController.isPurchased(item: power)
            )
            .contentShape(Rectangle())
          }
          .buttonStyle(.plain)
        }
      } header: {
        VStack(spacing: 10) {
          Image(viewModel.icon)
            .resizable()
            .frame(width: 80, height: 80)
          Text(viewModel.headerText)
            .font(.system(size: 16))
            .textCase(nil)
        }
        .padding(.bottom, 5)
        .padding(.top, -40)
        .centered()
      }
    }
    .navigationTitle(viewModel.title)
    .navigationBarTitleDisplayMode(.inline)
    .sheet(item: $unlockItem) { item in
      UnlockView(highlights: [item])
    }
  }
  
  /// Modally display a power's details.
  /// - Parameter power: The power to display.
  func show(power: Power) {
    if dataController.isPurchased(item: power) {
      UIViewController.topMost?.present {
        if viewModel.isReferenceView {
          PowerCard(power: power)
        } else {
          PowerCard(power: power, action: addPower)
        }
      }
    } else {
      unlockItem = power.unlockIdentifier
    }
  }
  
  /// Add a power to the view controller's referenced character.
  /// - Parameter power: The power to add.
  func addPower(_ power: Power) {
    viewModel.add(power: power)
    
    // presentationMode.wrappedValue.dismiss() only pops back to
    // the AddDisciplineSheet, so we need to dip into UIKit to
    // completely dismiss the sheet
    self.link.toggle() // Deactivate the CharacterDetail link so that we don't need to click twice
                       // to get here again
    UIViewController.root?.dismiss(animated: true)
  }
}

#if DEBUG
struct AddPowerSheet_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DisciplineDetail(discipline: Discipline.example, kindred: Kindred.example)
        .environmentObject(DataController.preview)
    }
  }
}
#endif
