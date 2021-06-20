//
//  AddCharacterView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/13/21.
//

import SwiftUI

struct AddCharacterView: View {
  
  @EnvironmentObject var dataController: DataController
  @Environment(\.presentationMode) var presentationMode
  
  @State private var showingFileImporter = false
  @State private var showingFileErrorAlert = false
  
  var body: some View {
    NavigationView {
      List {
        Section {
          NavigationLink(destination: CreateCharacterView(dataController: dataController)) {
            Label("Create new character", systemImage: "square.and.pencil")
          }
        }
        
        Section(footer: Text("Imports most data from an interactive character sheet PDF.")) {
          Button {
            showingFileImporter.toggle()
          } label: {
            Label("Import from PDF", systemImage: "arrow.up.doc")
          }
        }
        
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle("Add Kindred")
    }
    .fileImporter(isPresented: $showingFileImporter, allowedContentTypes: [.pdf], onCompletion: importCharacter)
    .alert(isPresented: $showingFileErrorAlert) {
      Alert(title: Text("Unable to open file"))
    }
  }
  
  func importCharacter<T: Error>(_ result: Result<URL, T>) {
    if case let .success(selectedFile) = result {
      if selectedFile.startAccessingSecurityScopedResource() {
        if let pdf = CharacterPDF(url: selectedFile) {
          CharacterImporter.importCharacter(pdf: pdf, dataController: dataController)
          dataController.save()
        }
      } else {
        // Unable to access file
        showingFileErrorAlert.toggle()
      }
      selectedFile.stopAccessingSecurityScopedResource()
    }
    presentationMode.wrappedValue.dismiss()
  }

}

struct AddKindredView_Previews: PreviewProvider {
  static var previews: some View {
    AddCharacterView()
      .environmentObject(DataController.preview)
  }
}
