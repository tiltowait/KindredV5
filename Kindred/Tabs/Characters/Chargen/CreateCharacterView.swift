//
//  CreateCharacterView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import SwiftUI

struct CreateCharacterView: View {
  
  @StateObject private var viewModel: ViewModel

  init(dataController: DataController) {
    let viewModel = ViewModel(dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List {
      Section(header: Text("Enter your character's basic information. Only the name is required. You will supply the rest of the details, including clan and traits, afterward.")) { }
        .textCase(nil)
      
      Section {
        BoldTextField("Name", binding: $viewModel.name)
        Button {
          viewModel.showClanSheet()
        } label: {
          BoldLabel(
            "Clan:",
            details: viewModel.selectedClan,
            layout: viewModel.clanIsSelected ? .standard : .placeholder
          )
          .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
      }
      
      Section {
        BoldTextField("Concept", binding: $viewModel.concept)
        BoldTextField("Ambition", binding: $viewModel.ambition)
        BoldTextField("Desire", binding: $viewModel.desire)
      }
      
      Section {
        DatePicker(selection: $viewModel.birthdate, in: ...Date(), displayedComponents: .date) {
          Text("Birthdate:")
            .bold()
        }
      }
      Section {
        Button("Create Character", action: createCharacter)
          .disabled(!viewModel.isCreatable)
          .centered()
        Button("Cancel", action: dismiss)
          .accentColor(.red)
          .centered()
      }
    }
    .listStyle(GroupedListStyle())
    .navigationTitle("Create Character")
    .sheet(isPresented: $viewModel.showingClanSheet) {
      NavigationView {
        ClanList(kindred: viewModel.dummyCharacter, dataController: viewModel.dataController)
      }
      .navigationViewStyle(StackNavigationViewStyle())
    }
    .onDisappear(perform: viewModel.deleteDummy)
  }
  
  func createCharacter() {
    viewModel.createCharacter()
    self.dismiss()
  }
  
  func dismiss() {
    // Use the root view controller, because this sheet is part
    // of a larger navigation stack
    viewModel.deleteDummy()
    UIViewController.root?.dismiss(animated: true)
  }
  
}

struct CreateCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      CreateCharacterView(dataController: DataController.preview)
    }
  }
}


