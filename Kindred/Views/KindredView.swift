//
//  KindredView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

// TODO: Create view model

import SwiftUI

struct KindredView: View {
  
  @StateObject var viewModel: ViewModel
  @Binding private var generation: Int16
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
    
    _generation = Binding(
      get: { viewModel.kindred.generation },
      set: { viewModel.kindred.generation = $0 }
    )
  }
  
  var body: some View {
    List {
      Section(header: ScrollingImageHeader(kindred: viewModel.kindred, dataController: viewModel.dataController)) {
        BoldLabelView("Ambition", details: viewModel.kindred.ambition)
        BoldLabelView("Desire", details: viewModel.kindred.desire)
        RangePicker("Generation", selection: $generation, range: 4...16)
      }
      
      Section(header: Text("Traits")) {
        NavigationLink(destination: TraitBlockView(kindred: viewModel.kindred, dataController: viewModel.dataController, traits: .attributes)) {
          TraitBlockPreview(title: "Attributes", traits: viewModel.zippedAttributes)
        }
        NavigationLink(destination: TraitBlockView(kindred: viewModel.kindred, dataController: viewModel.dataController, traits: .skills)) {
          TraitBlockPreview(title: "Abilities", traits: viewModel.zippedAbilities)
        }
      }
      
      Section(header: Text("Trackers")) {
        derivedTrait("Health", rating: viewModel.kindred.health, max: 15)
        derivedTrait("Willpower", rating: viewModel.kindred.willpower, max: 15)
        derivedTrait("Humanity", rating: viewModel.kindred.humanity, max: 10)
        derivedTrait("Hunger", rating: viewModel.kindred.hunger, max: 5)
        derivedTrait("Blood Potency", rating: viewModel.kindred.bloodPotency, max: 10)
      }
    }
    .listStyle(GroupedListStyle())
    .navigationTitle(viewModel.kindred.name)
    .onDisappear(perform: viewModel.save)
  }
  
  func derivedTrait(_ trait: String, rating: Int16, max: Int) -> some View {
    VStack {
      Text(trait)
        .font(.subheadline)
        .bold()
      DotView(rating: rating, max: max)
    }
  }
  
}

//struct KindredView_Previews: PreviewProvider {
//  static var previews: some View {
//    KindredView(kindred: Kindred.example)
//  }
//}
