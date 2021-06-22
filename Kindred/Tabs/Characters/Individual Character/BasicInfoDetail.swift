//
//  BasicInfoDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/16/21.
//

import SwiftUI

struct BasicInfoDetail: View {
  
  @StateObject var viewModel: ViewModel
  
  init(kindred: Kindred) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    DisclosureGroup(isExpanded: $viewModel.isExpanded) {
      BoldTextField("Concept", binding: $viewModel.kindred.concept)
      BoldTextField("Chronicle", binding: $viewModel.kindred.chronicle)
      if let benefactorTerm = viewModel.benefactorTerm {
        BoldTextField(benefactorTerm, binding: $viewModel.kindred.sire)
      }
      BoldTextField("Title", binding: $viewModel.kindred.title)
      DatePicker(
        selection: $viewModel.birthdate,
        in: viewModel.birthdateRange,
        displayedComponents: .date
      ) {
        Text("Born:")
          .bold()
      }
      if let transition = viewModel.transitionTerm {
        DatePicker(
          selection: $viewModel.transitionDate,
          in: viewModel.embraceRange,
          displayedComponents: .date
        ) {
          Text("\(transition):")
            .bold()
        }
      }
      BoldTextField("Height", binding: $viewModel.kindred.height)
      BoldTextField("Weight", binding: $viewModel.kindred.weight)
    } label: {
      Text("Additional Details")
        .bold()
    }
  }
  
}

struct BasicInfoDetail_Previews: PreviewProvider {
  static var previews: some View {
    List {
      BasicInfoDetail(kindred: Kindred.example)
    }
  }
}
