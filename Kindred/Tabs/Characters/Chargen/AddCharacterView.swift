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
  @State private var showingLoadingIndicator = false
  @State private var importWarnings: [String: [String]]?
  
  var footer: some View {
    Text("Imports most data from an official interactive character sheet PDF. Certain details, such as Disciplines and Clan, must be spelled correctly.")
      .padding(.top)
  }
  
  var body: some View {
    ZStack {
      NavigationView {
        List {
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
      .sheet(item: $importWarnings) { warnings in
        WarningSheet(
          message: "The following items could not be found.",
          warnings: warnings
        ) {
          self.dismiss()
        }
      } // End NavigationView
      
      if showingLoadingIndicator {
        Color.black.opacity(0.5)
        LoadingIndicator("Importing Character")
      }
    }
  }
  
  func importCharacter<T: Error>(_ result: Result<URL, T>) {
    toggleLoadingIndicator()
    
    DispatchQueue.global(qos: .userInitiated).async {
      if case let .success(selectedFile) = result {
        if selectedFile.startAccessingSecurityScopedResource() {
          if let pdf = CharacterPDF(url: selectedFile) {
            CharacterImporter(
              pdf: pdf,
              context: dataController.container.viewContext
            ) { importer in
              dataController.save()
              
              if importer.importErrors.isEmpty {
                self.dismiss()
              } else {
                importWarnings = importer.importErrors
              }
            }
          } else {
            fileAlertMessage = "The selected file is not a valid V5 PDF."
          }
        } else {
          fileAlertMessage = "Unable to access the selected file."
        }
        selectedFile.stopAccessingSecurityScopedResource()
      }
      toggleLoadingIndicator()
    }
  }
  
  func makeWarning(errors: [String: [String]]) {
    var warnings = "The following items could not be found:\n\n"
    var warningBlocks: [String] = []
    for (category, items) in errors {
      let block = "\(category):\n\(items.joined(separator: ", "))"
      warningBlocks.append(block)
    }
    warnings.append(warningBlocks.joined(separator: "\n\n"))
  }
  
  
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
  
  func toggleLoadingIndicator() {
    withAnimation {
      showingLoadingIndicator.toggle()
    }
  }

}

struct AddKindredView_Previews: PreviewProvider {
  static var previews: some View {
    AddCharacterView()
      .environmentObject(DataController.preview)
  }
}
