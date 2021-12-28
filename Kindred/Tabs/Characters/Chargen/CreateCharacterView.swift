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
        TextField("Character name", text: $viewModel.name)
          .boldLabel("Name:")
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
        .buttonStyle(.plain)
      }
      
      Section {
        TextField("Overarching concept", text: $viewModel.concept)
          .boldLabel("Concept:")
        TextField("Long-term ambition", text: $viewModel.ambition)
          .boldLabel("Ambition:")
        TextField("Short-term desire", text: $viewModel.desire)
          .boldLabel("Desire:")
      }
      
      Section {
        DatePicker(selection: $viewModel.birthdate, in: ...Date(), displayedComponents: .date) {
          Text("**Birthdate:**")
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
    .listStyle(.grouped)
    .navigationTitle("Create Character")
    .sheet(isPresented: $viewModel.showingClanSheet) {
      NavigationView {
        ClanList(kindred: viewModel.dummyCharacter, dataController: viewModel.dataController)
      }
      .navigationViewStyle(.stack)
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


