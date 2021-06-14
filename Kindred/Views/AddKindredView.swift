//
//  AddKindredView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/13/21.
//

import SwiftUI

struct AddKindredView: View {
  
  @EnvironmentObject var dataController: DataController
  @Environment(\.presentationMode) var presentationMode
  
  @State private var showingFileImporter = false
  
  var body: some View {
    NavigationView {
      List {
        Section {
          NavigationLink(destination: Text("Create")) {
            Label("Create new character", systemImage: "square.and.pencil")
          }
        }
        
        Section(footer: Text("This function will pull in name, clan, generation, etc., plus abilities and attributes.")) {
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
  }
  
  func importCharacter<T: Error>(_ result: Result<URL, T>) {
    if case let Result.success(selectedFile) = result {
      if let pdf = CharacterPDF(url: selectedFile) {
        DispatchQueue.main.async {
          CharacterImporter.importCharacter(pdf: pdf, dataController: dataController)
          dataController.save()
        }
      }
    }
    presentationMode.wrappedValue.dismiss()
  }

}

struct AddKindredView_Previews: PreviewProvider {
  static var previews: some View {
    AddKindredView()
      .environmentObject(DataController.preview)
  }
}
