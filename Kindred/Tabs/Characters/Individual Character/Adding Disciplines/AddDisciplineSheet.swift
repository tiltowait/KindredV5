//
//  AddDisciplineSheet.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct AddDisciplineSheet: View {
  
  @StateObject private var viewModel: ViewModel
  @Environment(\.presentationMode) var presentationMode
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var inClan: some View {
    Group {
      if let disciplines = viewModel.inClanDisciplines {
        ForEach(disciplines) { discipline in
          DisciplineRow(discipline: discipline)
        }
      } else {
        Text("No clan selected")
          .foregroundColor(.secondary)
      }
    }
  }
  
  var knownOutOfClan: some View {
    ForEach(viewModel.knownOutOfClanDisciplines) { discipline in
      DisciplineRow(discipline: discipline)
    }
  }
  
  var unknownOutOfClan: some View {
    ForEach(viewModel.unknownOutOfClanDisciplines) { discipline in
      DisciplineRow(discipline: discipline)
    }
  }
  
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("In-Clan")) {
          inClan
        }
        
        if !viewModel.knownOutOfClanDisciplines.isEmpty {
          Section(header: Text("Known Out-of-Clan")) {
            knownOutOfClan
          }
        }
        
        Section(header: Text("Out-of-Clan")) {
          unknownOutOfClan
        }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationBarTitle("Add Power", displayMode: .inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
          }
        }
      }
    }
  }
}

struct AddDisciplineSheet_Previews: PreviewProvider {
  static var previews: some View {
    AddDisciplineSheet(kindred: Kindred.example, dataController: DataController.preview)
  }
}
