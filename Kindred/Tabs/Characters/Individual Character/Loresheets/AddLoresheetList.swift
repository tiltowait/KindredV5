//
//  AddLoresheetList.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import SwiftUI

struct AddLoresheetList: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @StateObject var viewModel: ViewModel
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationView {
      List {
        loresheetSection("Known", loresheets: viewModel.knownLoresheets)
        loresheetSection("Unknown", loresheets: viewModel.unknownLoresheets)
      }
      .sheet(item: $viewModel.unlockIdentifier, onDismiss: viewModel.objectWillChange.send) { identifier in
        UnlockView(highlights: [identifier])
      }
      .navigationTitle("Add Loresheet")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: dismiss)
        }
      }
    }
  }
  
  @ViewBuilder func loresheetSection(_ title: LocalizedStringKey, loresheets: [Loresheet]) -> some View {
    if !loresheets.isEmpty {
      Section(header: Text(title)) {
        ForEach(loresheets) { loresheet in
          if viewModel.isUnlocked(loresheet: loresheet) {
            NavigationLink(
              destination: LoresheetDetail(
                loresheet: loresheet,
                kindred: viewModel.kindred
              )
            ) {
              ReferenceRow(loresheet.name, secondary: loresheet.pageReference)
            }
          } else {
            Button {
              viewModel.unlockIdentifier = loresheet.unlockIdentifier
            } label: {
              ReferenceRow(loresheet.name, secondary: loresheet.pageReference, unlocked: false)
            }
            .buttonStyle(.plain)
          }
        }
      }
    }
  }
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
}

#if DEBUG
struct AddLoresheetList_Previews: PreviewProvider {
  static var previews: some View {
    AddLoresheetList(kindred: Kindred.example, dataController: DataController.preview)
  }
}
#endif
