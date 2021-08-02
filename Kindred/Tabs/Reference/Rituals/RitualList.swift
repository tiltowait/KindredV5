//
//  RitualList.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/27/21.
//

import SwiftUI
import CoreData

struct RitualList: View, Identifiable {
  
  @StateObject private var viewModel: ViewModel
  var id = UUID()
  
  init(flavor: Ritual.Flavor, kindred: Kindred?, dataController: DataController) {
    let viewModel = ViewModel(
      flavor: flavor,
      kindred: kindred,
      dataController: dataController
    )
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List {
      ForEach(1...5) { level in
        Section(header: Text("Level \(level)")) {
          ForEach(viewModel.rituals[level]!) { ritual in
            Button {
              show(ritual: ritual)
            } label: {
              RitualRow(ritual: ritual)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
          }
        }
      }
    }
    .navigationBarTitle(viewModel.title, displayMode: .inline)
    .listStyle(InsetGroupedListStyle())
  }
  
  func show(ritual: Ritual) {
    UIViewController.topMost?.present {
      if viewModel.isReferenceView {
        RitualCard(ritual: ritual)
      } else {
        RitualCard(ritual: ritual, action: addRitual)
      }
    }
  }
  
  func addRitual(_ ritual: Ritual) {
    viewModel.add(ritual: ritual)
    
    // May need to add link toggling here, as in DisciplineDetail
    
    UIViewController.root?.dismiss(animated: true)
  }
  
}

struct RitualList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      RitualList(flavor: .ritual, kindred: nil, dataController: DataController.preview)
    }
  }
}
