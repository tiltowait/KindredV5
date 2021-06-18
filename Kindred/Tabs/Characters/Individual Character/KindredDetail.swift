//
//  KindredDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

// TODO: Create view model

import SwiftUI

struct KindredDetail: View {
  
  @StateObject var viewModel: ViewModel
  
  @State private var showingDiceRoller = false
  @State private var showingRenameAlert = false
  @State private var showingPowerAdder = false
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var menu: some View {
    Menu {
      Button {
        showingRenameAlert.toggle()
      } label: {
        Label("Rename \(viewModel.kindred.name)", systemImage: "rectangle.and.pencil.and.ellipsis")
      }
      Button {
        showingDiceRoller.toggle()
      } label: {
        Label("Roll dice", systemImage: "diamond.fill")
          .imageScale(.large)
      }
      
    // Menu label
    } label: {
      Label("Menu", systemImage: "ellipsis.circle")
        .imageScale(.large)
    }
  }
  
  var body: some View {
      List {
        // Basic info
        Section(header: ScrollingImageHeader(kindred: viewModel.kindred, dataController: viewModel.dataController)) {
          BoldLabel("Ambition", details: viewModel.kindred.ambition)
          BoldLabel("Desire", details: viewModel.kindred.desire)
          RangePicker("Generation", selection: $viewModel.kindred.generation, range: 4...16)
          BasicInfoDetail(kindred: viewModel.kindred)
        }
        
        // Traits
        Section(header: Text("Traits")) {
          NavigationLink(destination: TraitBlock(kindred: viewModel.kindred, dataController: viewModel.dataController, traits: .attributes)) {
            TraitSummary(title: "Attributes", traits: viewModel.zippedAttributes)
          }
          NavigationLink(destination: TraitBlock(kindred: viewModel.kindred, dataController: viewModel.dataController, traits: .skills)) {
            TraitSummary(title: "Abilities", traits: viewModel.zippedAbilities)
          }
        }
        
        // Disciplines
        Section(header: AdvantageHeader("Disciplines", binding: $showingPowerAdder)) {
          KnownDisciplinesGroups(kindred: viewModel.kindred, dataController: viewModel.dataController)
        }
        
        // Trackers (HP, WP, Humanity, Blood Potency)
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
      .toolbar {
        menu
      }
      .sheet(isPresented: $showingDiceRoller) {
        DiceRollView(kindred: viewModel.kindred)
      }
      .alert(isPresented: $showingRenameAlert, renameAlert)
      .onDisappear(perform: viewModel.save)
      .sheet(isPresented: $showingPowerAdder) {
        AddDisciplineSheet(kindred: viewModel.kindred, dataController: viewModel.dataController)
      }
  }
  
  func derivedTrait(_ trait: String, rating: Int16, max: Int) -> some View {
    VStack {
      Text(trait)
        .font(.subheadline)
        .bold()
      DotView(rating: rating, max: max)
    }
  }
  
  var renameAlert: TextFieldAlert {
    TextFieldAlert(
      title: "Rename \(viewModel.kindred.name)",
      message: nil,
      placeholder: "Enter the new name here"
    ) { newName in
      if let newName = newName {
        $viewModel.kindred.name.wrappedValue = newName
      }
    }
  }
  
}

struct KindredDetail_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      KindredDetail(kindred: Kindred.example, dataController: DataController.preview)
    }
  }
}
