//
//  CharacterRitualsList.swift
//  Kindred
//
//  Created by Jared Lindsay on 8/2/21.
//

import SwiftUI

struct CharacterRitualsList: View {
  
  @StateObject private var viewModel: ViewModel
  @State private var ritualList: RitualList?
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List {
      Section(header: Text("Experience cost: Level × 3")) { }
      
      // At present, there are only two ritual schools in the game;
      // however, if more are added, this will allow us to easily
      // add more with minimal work.
      
      ForEach(viewModel.availableSchools, id: \.rawValue) { school in
        section(school: school)
      }
    }
    .navigationTitle("Rituals")
    .navigationBarTitleDisplayMode(.inline)
    .sheet(item: $ritualList) { list in
      NavigationView {
        list
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                ritualList = nil
              }
            }
          }
      }
    }
    .sheet(item: $viewModel.lockedItemIdentifier) { item in
      UnlockView(highlights: [item])
    }
    .onDisappear(perform: viewModel.save)
  }
  
  func section(school: Ritual.Flavor) -> some View {
    let rituals = viewModel.rituals(forSchool: school)
    
    return Section {
      if rituals.isEmpty {
        Button {
          presentRituals(school: school)
        } label: {
          Label("Add item", systemImage: "plus.circle")
        }
      } else {
        ForEach(rituals) { ritual in
          Button {
            show(ritual: ritual)
          } label: {
            RitualRow(
              ritual: ritual,
              showLevel: true,
              isUnlocked: viewModel.isUnlocked(item: ritual)
            )
            .contentShape(Rectangle())
          }
          .buttonStyle(.plain)
        }
        .onDelete { offsets in
          removeRituals(school: school, offsets: offsets)
        }
      }
    } header: {
      HStack {
        Text(viewModel.sectionTitle(school: school))
        Spacer()
        Button {
          presentRituals(school: school)
        } label: {
          Label("Add ritual", systemImage: "plus.circle")
            .labelStyle(.iconOnly)
        }
      }
    }
  }
  
  /// Show the ritual's detail card.
  /// - Parameter ritual: The ritual to show.
  func show(ritual: Ritual) {
    if viewModel.isUnlocked(item: ritual) {
      UIViewController.topMost?.present {
        RitualCard(ritual: ritual)
      }
    } else {
      viewModel.lockedItemIdentifier = ritual.unlockIdentifier
    }
  }
  
  /// Present the ritual selection list.
  /// - Parameter school: The school to present.
  func presentRituals(school: Ritual.Flavor) {
    ritualList = RitualList(flavor: school, kindred: viewModel.kindred, dataController: viewModel.dataController)
  }
  
  /// Remove rituals of a given school.
  /// - Parameters:
  ///   - school: The school from which to remove the rituals.
  ///   - offsets: The indices of the rituals to remove.
  func removeRituals(school: Ritual.Flavor, offsets: IndexSet) {
    withAnimation {
      viewModel.removeRituals(school: school, offsets: offsets)
    }
  }
  
}

#if DEBUG
struct CharacterRitualsList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      CharacterRitualsList(kindred: Kindred.example, dataController: DataController.preview)
    }
  }
}
#endif
