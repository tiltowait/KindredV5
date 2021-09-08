//
//  AdvantageOptionView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import SwiftUI

struct AdvantageOptionView: View {
  
  @StateObject var viewModel: ViewModel
  @State private var redraw = false
  
  init(option: AdvantageOption, kindred: Kindred?, dataController: DataController) {
    let viewModel = ViewModel(option: option, kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
    
  }
  
  init(container: AdvantageContainer, dataController: DataController) {
    let viewModel = ViewModel(container: container, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var imageName: String {
    if viewModel.status == .uncontained {
      return "plus.circle"
    }
    return "checkmark.circle"
  }
  
  /// Button that adds the advantage option to the current character.
  var addButton: some View {
    Button(action: addToCharacter) {
      Image(systemName: imageName)
        .imageScale(.large)
    }
    .disabled(viewModel.status == .contained)
  }
  
  var buyButton: some View {
    Button {
      viewModel.showingUnlockSheet.toggle()
    } label: {
      Label("Unlock", systemImage: "lock.fill")
    }
  }
  
  var body: some View {
    HStack(alignment: .center, spacing: 5) {
      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          // No range. Show dots or squares.
          if viewModel.isUnlocked {
            if let magnitude = viewModel.singleOptionMagnitude {
              AdvantageOptionMarker(
                count: magnitude,
                square: viewModel.option.isFlaw
              )
            }
          } else {
            Image(systemName: "lock.fill")
              .foregroundColor(.secondary)
          }
          Text(viewModel.option.name)
            .bold()
          
          // Reference. Ex: "(• to •••)"
          if viewModel.showRatingRange {
            Text(
              ratingRange(
                min: viewModel.option.minRating,
                max: viewModel.option.maxRating
              )
            )
            .italic()
          }
          
          Spacer()
        }
        
        if viewModel.isUnlocked {
          Text(viewModel.option.info)
            .foregroundColor(.secondary)
            .lineLimitFix()
        } else {
          Text("You must purchase the \(viewModel.option.sourceBook.title) module to view this Advantage.")
            .foregroundColor(.secondary)
        }
        
        HStack {
          // Non-reference. Attached to character.
          if viewModel.showRatingSelection {
            Text("Rating:")
              .bold()
              .italic()
            DotSelector(
              current: $viewModel.currentRating,
              min: viewModel.minAllowableRating,
              max: viewModel.maxAllowableRating
            )
          } else if viewModel.isUnlocked == false {
            buyButton
              .padding(.horizontal)
              .padding(.vertical, 5)
              .background(Color.tertiarySystemGroupedBackground)
              .clipShape(Capsule())
          }
          Spacer()
          Text(viewModel.option.pageReference)
            .font(.caption2)
            .italic()
            .foregroundColor(.secondary)
            .lineLimit(5)
        }
        .padding(.top, 5)
      }
      if viewModel.status != .inapplicable {
        addButton
      }
    }
    .sheet(isPresented: $viewModel.showingUnlockSheet) {
      UnlockView(highlights: [viewModel.option.unlockIdentifier])
    }
  }
  
  /// Generate a string like "(• to •••)".
  /// - Parameters:
  ///   - min: The minimum number of dots.
  ///   - max: The maximum number of dots.
  /// - Returns: The generated string.
  func ratingRange(min: Int16, max: Int16) -> String {
    "(\(String(repeating: "•", count: Int(abs(min)))) to \(String(repeating: "•", count: Int(abs(max)))))"
  }
  
  /// Add the current AdvantageOption to the current character.
  func addToCharacter() {
    viewModel.addToCharacter()
    UIViewController.root?.dismiss(animated: true)
  }
  
}

#if DEBUG
struct AdvantageOptionView_Previews: PreviewProvider {
  
  static let context = DataController.preview.container.viewContext
  static let unbondable = "Unbondable"
  static let organovore = "Organovore"
  static let bondResistance = "Bond Resistance"
  
  static let container1 = Kindred.example.advantageContainers.first(where: { $0.option.name == "Bond Resistance" })!
  
  static let container2 = Kindred.example.advantageContainers.first(where: { $0.option.name == "Stunning" })!
  
  static let container3 = Kindred.example.advantageContainers.first(where: { $0.option.name == "Organovore" })!
  
  static var previews: some View {
    // No rating range, circle dots, no button
    AdvantageOptionView(option: AdvantageOption.fetchObject(named: unbondable, in: context)!, kindred: nil, dataController: DataController.preview)
      .previewLayout(.sizeThatFits)
    
    // Rating range, no button
    AdvantageOptionView(option: AdvantageOption.fetchObject(named: bondResistance, in: context)!, kindred: nil, dataController: DataController.preview)
      .previewLayout(.sizeThatFits)
    
    // No rating range, square dots, add button
    AdvantageOptionView(option: AdvantageOption.fetchObject(named: organovore, in: context)!, kindred: Kindred.example, dataController: DataController.preview)
      .previewLayout(.sizeThatFits)
    
    // No rating range, square dots, no add button, contained
    AdvantageOptionView(container: container2, dataController: DataController.preview)
      .previewLayout(.sizeThatFits)
    
    // No rating range, no button, selection range
    AdvantageOptionView(container: container1, dataController: DataController.preview)
      .previewLayout(.sizeThatFits)
  }
}
#endif
