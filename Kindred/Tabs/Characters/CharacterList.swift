//
//  CharacterList.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/13/21.
//

import SwiftUI

struct CharacterList: View {
  
  @StateObject var viewModel: ViewModel
  
  init(dataController: DataController) {
    let viewModel = ViewModel(dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  @ViewBuilder var characterList: some View {
    if !viewModel.unknown.isEmpty {
      section(named: "Unknown", for: viewModel.unknown)
    }
    if !viewModel.kindred.isEmpty {
      section(named: "Vampire", for: viewModel.kindred)
    }
    if !viewModel.ghouls.isEmpty {
      section(named: "Ghoul", for: viewModel.ghouls)
    }
    if !viewModel.mortals.isEmpty {
      section(named: "Mortal", for: viewModel.mortals)
    }
  }
  
  var body: some View {
    NavigationView {
      List {
        if viewModel.hasCharacters {
          characterList
        } else {
          Button("Add a character", action: viewModel.addCharacter)
        }
      }
      .listStyle(.insetGrouped)
      .navigationTitle("Characters")
      .toolbar {
        Button(action: viewModel.addCharacter) {
          Label("Add Character", systemImage: "plus")
        }
      }
      Text("Select or create a character to begin.")
        .foregroundColor(.secondary)
    }
    .phoneOnlyStackNavigationView()
    .sheet(isPresented: $viewModel.showingCreationSheet) {
      AddCharacterView()
        .allowAutoDismiss(false)
        .environmentObject(viewModel.dataController)
    }
    .sheet(item: $viewModel.unlockIdentifier) { identifier in
      UnlockView(highlights: [identifier])
    }
  }
  
  /// Generate a section for a group of characters.
  ///
  /// The characters can be deleted with ViewModel.delete(:_:).
  /// - Parameters:
  ///   - name: The name of the section.
  ///   - characters: The characters inside the section.
  /// - Returns: The generated section.
  func section(named name: LocalizedStringKey, for characters: [Kindred]) -> some View {
    Section(header: Text(name)) {
      ForEach(characters) { character in
        NavigationLink(
          destination: CharacterDetail(
            kindred: character,
            dataController: viewModel.dataController
          )
        ) {
          CharacterRow(kindred: character)
        }
        .id(character.id)
      }
      .onDelete { offsets in
        viewModel.delete(offsets, from: characters)
      }
    }
  }
  
}

struct CharacterList_Previews: PreviewProvider {
  static var previews: some View {
    CharacterList(dataController: DataController.preview)
      .environmentObject(DataController.preview)
      .environment(\.managedObjectContext, DataController.preview.container.viewContext)
  }
}
