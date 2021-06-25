//
//  TraitBlock.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

struct TraitBlock: View {
  
  @StateObject var viewModel: ViewModel
  
  /// Create a TraitBlockView.
  /// - Parameters:
  ///   - kindred: The `Kindred` to observe.
  ///   - dataController: The data controller responsible for saving and retrieving data.
  ///   - traits: The type of trait we are looking for: attributes or skills.
  init(kindred: Kindred, dataController: DataController, traits: ViewModel.TraitGroup) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController, traits: traits)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List {
      // Tell the user the XP cost to increase a trait
      Section(header: Text(viewModel.costToIncrease)) { }
      
      // Display the trait blocks
      section(named: "Physical", forTraits: viewModel.physical)
      section(named: "Social", forTraits: viewModel.social)
      section(named: "Mental", forTraits: viewModel.mental)
    }
    .listStyle(GroupedListStyle())
    .navigationBarTitle(viewModel.title)
    .onDisappear(perform: viewModel.save)
  }
  
  /// Generate a `List` `Section` of a given name for a given group of traits.
  ///
  /// The list will be populated by appropriately labeled `DotSelectorView`s.
  /// - Parameters:
  ///   - name: The name of the section.
  ///   - traits: The key paths to various traits.
  func section(named name: String, forTraits traits: [ReferenceWritableKeyPath<Kindred, Int16>]) -> some View {
    Section(header: Text(name)) {
      ForEach(traits, id: \.self) { trait in
        TraitRater(
          kindred: viewModel.kindred,
          keyPath: trait,
          max: 5,
          reference: viewModel.reference(forKeyPath: trait)
        )
      }
    }
  }
  
}

#if DEBUG
struct TraitBlock_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      TraitBlock(kindred: Kindred.example, dataController: DataController.preview, traits: .skills)
    }
  }
}
#endif
