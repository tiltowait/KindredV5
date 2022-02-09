//
//  CharacterDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

// TODO: Create view model

import SwiftUI

struct CharacterDetail: View {
  
  @Environment(\.viewController) var viewController
  
  @StateObject var viewModel: ViewModel
  
  @State private var showingNotesSheet = false
  @State private var showingClanSelectionSheet = false
  @State private var showingDiceRoller = false
  @State private var showingRenameAlert = false
  @State private var showingPowerAdder = false
  @State private var lockedItem: String?
  
  @State private var pdfExporter: CharacterExporter?
  @State private var warningSheet: WarningSheet?
  
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
        Label("Rename", systemImage: "rectangle.and.pencil.and.ellipsis")
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
      
      Divider()
      
      Button(action: exportCharacter) {
        Label("Export character", systemImage: "square.and.arrow.up")
      }
      
    // Menu label
    } label: {
      Label("Menu", systemImage: "ellipsis.circle")
        .imageScale(.large)
    }
  }
  
  var details: some View {
    List {
      // Basic info
      Section {
        TextField("Long-term ambition", text: $viewModel.kindred.ambition)
          .boldLabel("Ambition:")
        
        TextField("Short-term desire", text: $viewModel.kindred.desire)
          .boldLabel("Desire:")
        
        clanLink
        
        if (viewModel.kindred.clan != nil) {
          RangePicker("Generation", selection: $viewModel.kindred.generation, range: 4...16)
        }
        
        NavigationLink(
          destination: BiographyDetail(
            kindred: viewModel.kindred,
            dataController: viewModel.dataController
          )
        ) {
          Text("Biography")
            .font(.headline)
        }
        
        NavigationLink(
          destination: ChronicleDetail(
            kindred: viewModel.kindred,
            dataController: viewModel.dataController
          )
        ) {
          Text("Chronicle")
            .font(.headline)
        }
        
        NavigationLink(
          destination: CharacterAdvantages(
            kindred: viewModel.kindred,
            dataController: viewModel.dataController
          )
        ) {
          Text("Advantages")
            .font(.headline)
        }
      } header: {
        ScrollingImageHeader(
          kindred: viewModel.kindred,
          dataController: viewModel.dataController
        )
          .padding(.bottom, 5)
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
            KnownDisciplinesGroups(
              kindred: viewModel.kindred,
              lockedItem: $lockedItem
            )
          }
        }
      }
      
      // Rituals
      if !viewModel.kindred.availableRitualSchools.isEmpty {
        NavigationLink("Rituals", destination:
                        CharacterRitualsList(
                          kindred: viewModel.kindred,
                          dataController: viewModel.dataController
                        )
        )
          .font(.headline)
      }
      
      // Trackers (HP, WP, Humanity, Blood Potency)
      Trackers(kindred: viewModel.kindred)
      
      if viewModel.kindred.clan?.template == .kindred {
        Section(header: Text("Blood Potency Details")) {
          BloodPotencyDetail(bloodPotency: BloodPotency(viewModel.kindred.bloodPotency))
        }
      }
      
    }
    .navigationTitle(viewModel.kindred.name)
    .toolbar {
      menu
    }
    .sheet(isPresented: $showingNotesSheet) {
      CharacterNotesView(kindred: viewModel.kindred)
    }
    .sheet(isPresented: $showingDiceRoller) {
      PoolSelector(kindred: viewModel.kindred)
    }
    .sheet(isPresented: $showingPowerAdder) {
      AddDisciplineSheet(kindred: viewModel.kindred, dataController: viewModel.dataController, link: $showingPowerAdder)
    }
    .sheet(isPresented: $showingClanSelectionSheet) {
      NavigationView {
        ClanList(kindred: viewModel.kindred, dataController: viewModel.dataController)
      }
    }
    .sheet(item: $pdfExporter) { exporter in
      ActivityViewController(activityItems: [exporter.fileURL], excludedActivityTypes: [.copyToPasteboard])
    }
    .sheet(item: $warningSheet) { warning in
      warning
    }
    .sheet(item: $lockedItem) { item in
      UnlockView(highlights: [item])
    }
    .alert(isPresented: $showingRenameAlert, renameCharacterAlert)
    .onAppear(perform: viewModel.generateTraitPreviews)
    .onDisappear(perform: viewModel.save)
  }
  
  var body: some View {
    Group {
      if viewModel.showDetails {
        details
      } else {
        Text("Select or create a character to begin.")
      }
    }
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
  @ViewBuilder var clanLink: some View {
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
      .buttonStyle(.plain)
    }
  }
  
  func changeClan() {
    showingClanSelectionSheet.toggle()
  }
  
  /// Prepare a character for export, showing a progress indicator while working.
  func exportCharacter() {
    viewController?.present {
      LoadingIndicator("Exporting Character")
    }
    DispatchQueue.global(qos: .userInitiated).async {
      let exporter = CharacterExporter(character: viewModel.kindred)
      
      // Dismiss the export indicator
      DispatchQueue.main.async {
        self.viewController?.dismiss(animated: true)
      }
      
      // If there were any users, we want to present them to the
      // user before exporting.
      
      if let warnings = exporter?.exportWarnings {
        warningSheet = WarningSheet(
          message: "The following items could not fit on the PDF.",
          warnings: warnings
        ) {
          self.pdfExporter = exporter
        }
      } else {
        self.pdfExporter = exporter
      }
    }
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
