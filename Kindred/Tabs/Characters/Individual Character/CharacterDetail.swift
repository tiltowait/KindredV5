//
//  CharacterDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

// TODO: Create view model

import SwiftUI

struct CharacterDetail: View {
  
  @StateObject var viewModel: ViewModel
  
  @State private var showingNotesSheet = false
  @State private var showingClanSelectionSheet = false
  @State private var showingDiceRoller = false
  @State private var showingRenameAlert = false
  @State private var showingPowerAdder = false
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  /// The character menu.
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
      Button {
        showingNotesSheet.toggle()
      } label: {
        Label("Character notes", systemImage: "note.text")
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
          BoldTextField("Ambition", binding: $viewModel.kindred.ambition)
          BoldTextField("Desire", binding: $viewModel.kindred.desire)
          clanLink
          if (viewModel.kindred.clan != nil) {
            RangePicker("Generation", selection: $viewModel.kindred.generation, range: 4...16)
          }
          BasicInfoDetail(kindred: viewModel.kindred)
          
          NavigationLink(
            destination: CharacterAdvantages(
              kindred: viewModel.kindred,
              dataController: viewModel.dataController
            )
          ) {
              Text("Advantages")
                .bold()
            }
        }
        
        // Traits
        Section(header: Text("Traits")) {
          NavigationLink(destination: TraitBlock(kindred: viewModel.kindred, dataController: viewModel.dataController, traits: .attributes)) {
            TraitSummary(title: "Attributes", traits: viewModel.attributePreviews)
          }
          NavigationLink(destination: TraitBlock(kindred: viewModel.kindred, dataController: viewModel.dataController, traits: .skills)) {
            TraitSummary(title: "Skills", traits: viewModel.skillPreviews)
          }
        }
        
        // Disciplines
        if viewModel.kindred.clan?.template != .mortal {
          Section(
            header: DisciplineHeader(buttonPressed: $showingPowerAdder)
          ) {
            if viewModel.noKnownDisciplines {
              Button {
                showingPowerAdder.toggle()
              } label: {
                Text("Tap to add a Discipline")
                  .foregroundColor(.secondary)
              }
            } else {
              KnownDisciplinesGroups(kindred: viewModel.kindred, dataController: viewModel.dataController)
            }
          }
        }
        
        // Trackers (HP, WP, Humanity, Blood Potency)
        Trackers(kindred: viewModel.kindred)
        
        // A bit of a kludge. Trackers has two display modes: edit and
        // view. The edit mode is shorter than the view mode, so when
        // switching between them, the view mode gets cut off at the
        // bottom. To prevent this, we put a gap at the bottom of the
        // list.
        //
        // It can't be padding attached to Trackers, or that causes
        // weird graphical glitches. It also can't be a Color.clear
        // by itself, because that creates a list row. Therefore, it
        // has to be a section header, which has no background and
        // doesn't create a list row.
        Section(header: Color.clear.frame(width: 1, height: 100)) { }
      }
      .listStyle(InsetGroupedListStyle())
      .navigationTitle(viewModel.kindred.name)
      .toolbar {
        menu
      }
      .sheet(isPresented: $showingNotesSheet) {
        CharacterNotesView(kindred: viewModel.kindred)
      }
      .sheet(isPresented: $showingDiceRoller) {
        DiceRollView(kindred: viewModel.kindred)
      }
      .alert(isPresented: $showingRenameAlert, renameCharacterAlert)
      .sheet(isPresented: $showingPowerAdder) {
        AddDisciplineSheet(kindred: viewModel.kindred, dataController: viewModel.dataController, link: $showingPowerAdder)
      }
      .sheet(isPresented: $showingClanSelectionSheet) {
        NavigationView {
          ClanList(kindred: viewModel.kindred, dataController: viewModel.dataController)
        }
      }
      .onAppear(perform: viewModel.generateTraitPreviews)
      .onDisappear(perform: viewModel.save)
  }
  
  /// Generates a "derived trait" view with tilte and appropriate dots.
  ///
  /// TODO: Make full health and willpower trackers and make everything editable.
  /// - Parameters:
  ///   - trait: The name of the trait.
  ///   - rating: The trait's current rating.
  ///   - max: The trait's maximum rating.
  /// - Returns: The generated view.
  func derivedTrait(_ trait: String, rating: Int16, max: Int) -> some View {
    VStack {
      Text(trait)
        .font(.subheadline)
        .bold()
      DotView(rating: rating, max: max)
    }
  }
  
  /// A TextFieldAlert for renaming the character.
  var renameCharacterAlert: TextFieldAlert {
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
  
  // MARK: - Clan Selection/Viewing
  
  /// A wrapper to a clan link.
  ///
  /// If the character has no clan, then the link will go to the clan list.
  /// If the character has a clan, the link goes directly to the clan details.
  var clanLink: some View {
    Group {
      if let clan = viewModel.kindred.clan {
        NavigationLink(destination: ClanDetail(clan: clan, kindred: viewModel.kindred, reselection: changeClan)) {
          BoldLabel("Clan:", details: viewModel.clanName, layout: .picker)
        }
      } else {
        Button {
          showingClanSelectionSheet.toggle()
        } label: {
          BoldLabel("Clan:", details: viewModel.clanName, layout: .picker)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
  }
  
  func changeClan() {
    showingClanSelectionSheet.toggle()
  }
  
}

#if DEBUG
struct KindredDetail_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      CharacterDetail(kindred: Kindred.example, dataController: DataController.preview)
    }
  }
}
#endif
