//
//  SpecialtyManager.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/13/21.
//

import SwiftUI

struct SpecialtyManager: View, Identifiable {
  
  let id = UUID()
  
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
        Section(header: Text("Specialties")) {
          ForEach(viewModel.specialties.indices, id: \.self) { index in
            TextField("Specialty", text: $viewModel.specialties[index])
          }
          .onDelete(perform: viewModel.removeSpecialties)
          
          Button(action: addSpecialty) {
            Label("Add specialty", systemImage: "plus.circle")
          }
        }
      }
      .navigationTitle(viewModel.skill)
      .navigationBarTitleDisplayMode(.inline)
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
    // Using topMost instead of presentationMode, because if
    // the user taps either the cancel or done buttons while
    // editing a specialty, the sheet will forever refuse
    // to dismiss.
    //
    // I believe this to be due to using the specialties array
    // as a binding, but I am not 100% sure at the moment, and
    // refactoring SpecialtyManager isn't worth the effort when
    // there is already an easy fix.
    UIViewController.topMost?.dismiss(animated: true)
  }
  
  func confirm() {
    binding = viewModel.commitChanges()
    dismiss()
  }
  
}

#if DEBUG
struct SpecialtyManager_Previews: PreviewProvider {
  static var previews: some View {
    SpecialtyManager(skill: "Occult", kindred: Kindred.example, dataController: DataController.preview, binding: .constant(nil))
  }
}
#endif
