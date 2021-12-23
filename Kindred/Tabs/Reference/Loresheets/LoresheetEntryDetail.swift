//
//  LoresheetEntryDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/7/21.
//

import SwiftUI

struct LoresheetEntryDetail: View {
  
  @StateObject var viewModel: ViewModel
  
  init(entry: LoresheetEntry, kindred: Kindred?) {
    let viewModel = ViewModel(entry: entry, kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var imageName: String {
    viewModel.buttonToShow == .add ? "plus.circle" : "checkmark.circle"
  }
  
  var dots: String {
    String(repeating: "•", count: Int(viewModel.entry.level))
  }
  
  var body: some View {
    HStack(alignment: .center, spacing: 5) {
      VStack(alignment: .leading) {
        Text("\(dots) \(viewModel.entry.name)")
          .bold()
        Text(viewModel.entry.info)
        
        HStack {
          Spacer()
        }
      }
      if viewModel.buttonToShow != .none {
        Button(action: addToKindred) {
          Image(systemName: imageName)
            .imageScale(.large)
            .labelStyle(.iconOnly)
        }
        .disabled(viewModel.buttonToShow == .have)
      }
    }
  }
  
  func addToKindred() {
    viewModel.addToKindred()
    UIViewController.topMost?.dismiss(animated: true)
  }
  
}

#if DEBUG
struct LoresheetEntryDetail_Previews: PreviewProvider {
  static var previews: some View {
    LoresheetEntryDetail(entry: LoresheetEntry.example, kindred: nil)
      .previewLayout(.sizeThatFits)
    
    LoresheetEntryDetail(entry: LoresheetEntry.example, kindred: Kindred.example)
      .previewLayout(.sizeThatFits)
  }
}
#endif
