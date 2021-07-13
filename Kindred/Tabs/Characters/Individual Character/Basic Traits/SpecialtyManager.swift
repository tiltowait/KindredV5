//
//  SpecialtyManager.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/13/21.
//

import SwiftUI

struct SpecialtyManager: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @StateObject var viewModel: ViewModel
  @Binding var binding: String?
  
  init(skill: String, kindred: Kindred, dataController: DataController, binding: Binding<String?>) {
    let viewModel = ViewModel(skill: skill, kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
    _binding = binding
  }
  
  var body: some View {
    NavigationView {
      List {
        ForEach(viewModel.specialties.indices, id: \.self) { index in
          TextField("Specialty", text: $viewModel.specialties[index])
        }
        .onDelete(perform: viewModel.removeSpecialties)
        
        Button(action: addSpecialty) {
          Label("Add specialty", systemImage: "plus.circle")
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationBarTitle("\(viewModel.skill) Specialties", displayMode: .inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: dismiss)
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Done", action: confirm)
        }
      }
    }
  }
  
  func addSpecialty() {
    withAnimation {
      viewModel.specialties.append("")
    }
  }
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
  
  func confirm() {
    binding = viewModel.commitChanges()
    dismiss()
  }
  
}

struct SpecialtyManager_Previews: PreviewProvider {
  static var previews: some View {
    SpecialtyManager(skill: "Occult", kindred: Kindred.example, dataController: DataController.preview, binding: .constant(nil))
  }
}
