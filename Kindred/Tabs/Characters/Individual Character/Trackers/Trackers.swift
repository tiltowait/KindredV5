//
//  Trackers.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/23/21.
//

import SwiftUI

struct Trackers: View {
  
  @StateObject var viewModel: ViewModel
  
  @State private var showingEditView = false
  
  init(kindred: Kindred) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var headerButton: some View {
    Button {
      withAnimation {
        showingEditView.toggle()
      }
    } label: {
      if showingEditView {
        Text("Done")
      } else {
        Label("Edit", systemImage: "square.and.pencil")
          .labelStyle(IconOnlyLabelStyle())
      }
    }
  }
  
  var header: some View {
    HStack {
      Text("Trackers")
      Spacer()
      headerButton
    }
  }
  
  var modifyView: some View {
    VStack {
      TrackerStepper("Health:", value: $viewModel.kindred.health, in: 4...15, onIncrement: viewModel.incrementHealth, onDecrement: viewModel.decrementHealth)
      TrackerStepper("Willpower:", value: $viewModel.kindred.willpower, in: 3...15, onIncrement: viewModel.incrementWillpower, onDecrement: viewModel.decrementWillpower)
      
      Divider()
      
      TrackerStepper("Humanity:", value: $viewModel.kindred.humanity, in: 0...10)
      TrackerStepper("Blood Potency:", value: $viewModel.kindred.bloodPotency, in: 0...10)
      
      Divider()
      
      TrackerStepper("Hunger:", value: $viewModel.kindred.hunger, in: 0...5)
    }
  }
  
  var trackers: some View {
    VStack {
      StressTrack("Health", track: $viewModel.kindred.healthString)
        .padding(.bottom, 5)
        .centered()
      Divider()
      StressTrack("Willpower", track: $viewModel.kindred.willpowerString)
        .padding(.bottom, 5)
        .centered()
      Divider()
      tracker("Humanity", rating: viewModel.kindred.humanity, max: 10)
      Divider()
      tracker("Blood Potency", rating: viewModel.kindred.bloodPotency, max: 10)
      Divider()
      tracker("Hunger", rating: viewModel.kindred.hunger, max: 5)
    }
  }
  
  var body: some View {
    Section(header: header) {
      if showingEditView {
        modifyView
      } else {
        trackers
      }
    }
  }
  
  /// Create a tracker display for a given trait.
  /// - Parameters:
  ///   - label: The name of the trait.
  ///   - rating: The trait's current rating.
  ///   - max: The maximum possible value of that trait.
  /// - Returns: The tracker's display.
  func tracker(_ label: LocalizedStringKey, rating: Int16, max: Int) -> some View {
    VStack {
      Text(label)
        .bold()
      DotView(rating: rating, max: max)
    }
    .padding(.bottom, 5)
  }
  
}

#if DEBUG
struct Trackers_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        Trackers(kindred: Kindred.example)
      }
      .listStyle(InsetGroupedListStyle())
    }
  }
}
#endif
