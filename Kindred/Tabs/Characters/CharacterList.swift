//
//  CharacterList.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/13/21.
//

import SwiftUI

struct CharacterList: View {
  
  @StateObject var viewModel: ViewModel
  
  @State private var showingCreationSheet = false
  
  init(dataController: DataController) {
    let viewModel = ViewModel(dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var characterList: some View {
    Group {
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
  }
  
  var body: some View {
    NavigationView {
      List {
        Group {
          if viewModel.hasCharacters {
            characterList
          } else {
            Text("Press + to add a character.")
              .foregroundColor(.secondary)
          }
        }
      }
      .navigationTitle("Characters")
      .listStyle(InsetGroupedListStyle())
      .toolbar {
        Button {
          showingCreationSheet.toggle()
        } label: {
          Label("Add Kindred", systemImage: "plus")
        }
      }
    }
    .sheet(isPresented: $showingCreationSheet) {
      AddCharacterView()
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
