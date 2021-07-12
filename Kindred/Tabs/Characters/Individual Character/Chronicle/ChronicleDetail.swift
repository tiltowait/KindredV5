//
//  ChronicleDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/12/21.
//

import SwiftUI

struct ChronicleDetail: View {
  
  @StateObject var viewModel: ViewModel
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List {
      BoldTextField("Chronicle", binding: $viewModel.chronicle)
      DatePicker(
        selection: $viewModel.inGameDate,
        displayedComponents: .date
      ) {
        Text("In-game date:")
          .bold()
      }
      
      Section(header: Text("Chronicle Tenets")) {
        ForEach(viewModel.tenets.indices, id: \.self) { index in
          TextField("Tenet", text: $viewModel.tenets[index])
        }
        .onDelete(perform: viewModel.removeTenet)
        
        Button(action: addTenet) {
          Label("Add chronicle tenet", systemImage: "plus.circle")
        }
      }
      
      Section(header: Text("Convictions")) {
        ForEach(viewModel.convictions.indices, id: \.self) { index in
          TextField("Conviction", text: $viewModel.convictions[index])
        }
        .onDelete(perform: viewModel.removeConviction)
        
        Button(action: addConviction) {
          Label("Add conviction", systemImage: "plus.circle")
        }
      }
      
      Section(header: Text("Touchstones")) {
        ForEach(viewModel.touchstones.indices, id: \.self) { index in
          TextField("Touchstone", text: $viewModel.touchstones[index])
        }
        .onDelete(perform: viewModel.removeTouchstone)
        
        Button(action: addTouchstone) {
          Label("Add touchstone", systemImage: "person.circle")
        }
      }
      
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarTitle("Chronicle", displayMode: .inline)
    .onDisappear(perform: viewModel.commitChanges)
  }
  
  func addTenet() {
    withAnimation {
      viewModel.add(.tenet)
    }
  }
  
  func addConviction() {
    withAnimation {
      viewModel.add(.conviction)
    }
  }
  
  func addTouchstone() {
    withAnimation {
      viewModel.add(.touchstone)
    }
  }
}

struct ChronicleDetail_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ChronicleDetail(kindred: Kindred.example, dataController: DataController.preview)
    }
  }
}
