//
//  AdvantageOptionView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import SwiftUI

struct AdvantageOptionView: View {
  
  @StateObject var viewModel: ViewModel
  
  init(option: AdvantageOption, kindred: Kindred?, dataController: DataController?) {
    let viewModel = ViewModel(option: option, kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  init(container: AdvantageContainer) {
    let viewModel = ViewModel(container: container)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var imageName: String {
    if viewModel.status == .uncontained {
      return "plus.circle"
    }
    return "checkmark.circle"
  }
  
  var addButton: some View {
    Button(action: addToCharacter) {
      Image(systemName: imageName)
        .imageScale(.large)
    }
    .disabled(viewModel.status == .contained)
  }
  
  var body: some View {
    HStack(alignment: .center, spacing: 5) {
      VStack(alignment: .leading) {
        HStack(alignment: .center) {
          if let magnitude = viewModel.singleOptionMagnitude {
            markers(count: magnitude)
          }
          Text(viewModel.option.name)
            .bold()
          if viewModel.showRatingRange {
            Text("(\(dots(count: viewModel.option.minRating)) to \(dots(count: viewModel.option.maxRating)))")
              .italic()
          }
          Spacer()
        }

        Text(viewModel.option.info)
          .foregroundColor(.secondary)
          .lineLimitFix()
        
        HStack {
          if viewModel.showRatingSelection {
            Text("Rating:")
              .bold()
              .italic()
            DotSelector(
              current: $viewModel.currentRating,
              min: viewModel.minAllowableRating,
              max: viewModel.maxAllowableRating
            )
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
  }
    
  func markers(count: Int) -> some View {
    HStack {
      ForEach(0..<count) { _ in
        shape
      }
    }
  }
  
  func dots(count: Int16) -> String {
    String(repeating: "•", count: Int(abs(count)))
  }
  
  var shape: some View {
    Group {
      if viewModel.option.isFlaw {
        Rectangle()
          .fill(Color.black)
          .frame(width: 8, height: 8)
      } else {
        Circle()
          .fill(Color.black)
          .frame(width: 6, height: 6)
      }
    }
  }
  
  func addToCharacter() {
    viewModel.addToCharacter()
    UIViewController.root?.dismiss(animated: true)
  }
  
}

struct AdvantageOptionView_Previews: PreviewProvider {
  
  static let context = DataController.preview.container.viewContext
  static let unbondable = "Unbondable"
  static let organovore = "Organovore"
  static let bondResistance = "Bond Resistance"
  
  static let container = Kindred.example.advantageContainers.first(where: { $0.option.name == "Bond Resistance" })!
  
  static var previews: some View {
    // No rating range, circle dots, no button
    AdvantageOptionView(option: AdvantageOption.fetchObject(named: unbondable, in: context)!, kindred: nil, dataController: nil)
      .previewLayout(.sizeThatFits)
    
    // Rating range, no button
    AdvantageOptionView(option: AdvantageOption.fetchObject(named: bondResistance, in: context)!, kindred: nil, dataController: nil)
      .previewLayout(.sizeThatFits)
    
    // No rating range, square dots, add button
    AdvantageOptionView(option: AdvantageOption.fetchObject(named: organovore, in: context)!, kindred: Kindred.example, dataController: DataController.preview)
      .previewLayout(.sizeThatFits)
    
    // No rating range, no button, selection range
    AdvantageOptionView(container: container)
      .previewLayout(.sizeThatFits)
  }
}
