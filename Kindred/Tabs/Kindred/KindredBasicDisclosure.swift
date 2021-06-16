//
//  KindredBasicDisclosure.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/16/21.
//

import SwiftUI

struct KindredBasicDisclosure: View {
  
  @StateObject var viewModel: ViewModel
  
  init(kindred: Kindred) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    DisclosureGroup("Additional Details", isExpanded: $viewModel.isExpanded) {
      BoldTextField("Concept", binding: $viewModel.kindred.concept)
      BoldTextField("Chronicle", binding: $viewModel.kindred.chronicle)
      BoldTextField("Sire", binding: $viewModel.kindred.sire)
      BoldTextField("Title", binding: $viewModel.kindred.title)

      DatePicker(selection: $viewModel.birthdate, in: ...Date(), displayedComponents: .date) {
        Text("Birthdate:")
          .bold()
      }
      DatePicker(selection: $viewModel.embraceDate, in: ...Date(), displayedComponents: .date) {
        Text("Embrace date:")
          .bold()
      }
      
      BoldTextField("Height", binding: $viewModel.kindred.height)
      BoldTextField("Weight", binding: $viewModel.kindred.weight)

    }
  }
  
}

struct KindredBasicDisclosure_Previews: PreviewProvider {
  static var previews: some View {
    List {
      KindredBasicDisclosure(kindred: Kindred.example)
    }
  }
}
