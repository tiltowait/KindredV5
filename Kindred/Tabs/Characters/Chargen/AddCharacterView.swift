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
  @State private var fileAlertMessage: String?
  
  var footer: some View {
    Text("Imports most data from an interactive character sheet PDF. Certain details, such as disciplines and clan, must be an exact match in order for the importer to find them.")
      .padding(.top)
  }
  
  var body: some View {
    NavigationView {
      List {
        Section { } // Empty section for spacing

        NavigationLink(destination: CreateCharacterView(dataController: dataController)) {
          Label("Create new character", systemImage: "square.and.pencil")
        }
        
        Section(footer: footer) {
          Button {
            showingFileImporter.toggle()
          } label: {
            Label("Import from PDF", systemImage: "arrow.up.doc")
          }
        }
        
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle("Add Character")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: dismiss)
        }
      }
    }
    .fileImporter(isPresented: $showingFileImporter, allowedContentTypes: [.pdf], onCompletion: importCharacter)
    .alert(item: $fileAlertMessage) { message in
      Alert(
        title: Text("Error importing PDF"),
        message: Text(message),
        dismissButton: .default(Text("OK"))
      )
    }
  }
  
  func importCharacter<T: Error>(_ result: Result<URL, T>) {
    if case let .success(selectedFile) = result {
      if selectedFile.startAccessingSecurityScopedResource() {
        if let pdf = CharacterPDF(url: selectedFile) {
          CharacterImporter.importCharacter(
            pdf: pdf,
            context: dataController.container.viewContext
          )
          dataController.save()
          self.dismiss()
        } else {
          fileAlertMessage = "The selected file is not a valid V5 PDF."
        }
      } else {
        fileAlertMessage = "Unable to access the selected file."
      }
      selectedFile.stopAccessingSecurityScopedResource()
    }
  }
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }

}

struct AddKindredView_Previews: PreviewProvider {
  static var previews: some View {
    AddCharacterView()
      .environmentObject(DataController.preview)
  }
}
