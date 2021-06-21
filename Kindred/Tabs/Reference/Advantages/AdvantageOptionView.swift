//
//  AdvantageOptionView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import SwiftUI

struct AdvantageOptionView: View {
  
  @StateObject var viewModel: ViewModel
  
  init(option: AdvantageOption) {
    let viewModel = ViewModel(option: option)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var decoratorString: String? {
    if let magnitude = viewModel.singleOptionMagnitude {
      let dot = viewModel.option.isFlaw ? "▪️" : "•"
      return String(repeating: dot, count: magnitude)
    }
    return nil
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
        if let magnitude = viewModel.singleOptionMagnitude {
          markers(count: magnitude)
        }
        Text(viewModel.option.name)
          .bold()
        if !viewModel.isSingleOption {
          Text("(\(dots(count: viewModel.option.minRating)) to \(dots(count: viewModel.option.maxRating)))")
            .italic()
        }
        Spacer()
      }

      Text(viewModel.option.info)
        .foregroundColor(.secondary)
        .lineLimitFix()
      
      HStack {
        Spacer()
        Text(viewModel.option.pageReference)
          .font(.caption2)
          .italic()
          .foregroundColor(.secondary)
      }
      .padding(.top, 5)
      
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
}

struct AdvantageOptionView_Previews: PreviewProvider {
  
  static let context = DataController.preview.container.viewContext
  static let unbondable = "Unbondable"
  static let adversary = "Adversary"
  static let organovore = "Organovore"
  static let bondResistance = "Bond Resistance"
  
  static var previews: some View {
    AdvantageOptionView(option: AdvantageOption.fetchObject(named: unbondable, in: context)!)
      .previewLayout(.sizeThatFits)
    AdvantageOptionView(option: AdvantageOption.fetchObject(named: bondResistance, in: context)!)
      .previewLayout(.sizeThatFits)
    AdvantageOptionView(option: AdvantageOption.fetchObject(named: adversary, in: context)!)
      .previewLayout(.sizeThatFits)
    AdvantageOptionView(option: AdvantageOption.fetchObject(named: organovore, in: context)!)
      .previewLayout(.sizeThatFits)
  }
}
