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
        if let rituals = viewModel.rituals(level: level) {
          Section(header: Text("Level \(level)")) {
            ForEach(rituals) { ritual in
              Button {
                show(ritual: ritual)
              } label: {
                RitualRow(ritual: ritual, showLevel: false, isUnlocked: viewModel.isUnlocked(ritual: ritual))
                  .contentShape(Rectangle())
              }
              .buttonStyle(.plain)
            }
          }
        }
      }
    }
    .navigationTitle(viewModel.title)
    .navigationBarTitleDisplayMode(.inline)
    .sheet(item: $viewModel.lockedRitual) { ritual in
      UnlockView(highlights: [ritual])
    }
  }
  
  func show(ritual: Ritual) {
    if viewModel.isUnlocked(ritual: ritual) {
      UIViewController.topMost?.present {
        if viewModel.isReferenceView {
          RitualCard(ritual: ritual)
        } else {
          RitualCard(ritual: ritual, action: addRitual)
        }
      }
    } else {
      viewModel.lockedRitual = ritual.unlockIdentifier
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
