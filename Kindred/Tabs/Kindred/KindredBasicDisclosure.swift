//
//  KindredBasicDisclosure.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/16/21.
//

import SwiftUI

struct KindredBasicDisclosure: View {
  
  @State private var isExpanded = false
  @StateObject var viewModel: ViewModel
  
  init(kindred: Kindred) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    DisclosureGroup("Additional Details") {
      if viewModel.showConcept {
        BoldLabel("Concept", details: viewModel.kindred.concept)
      }
      if viewModel.showChronicle {
        BoldLabel("Chronicle", details: viewModel.kindred.chronicle)
      }
      if viewModel.showSire {
        BoldLabel("Sire", details: viewModel.kindred.sire)
      }
      if viewModel.showTitle {
        BoldLabel("Title", details: viewModel.kindred.title)
      }
      if let birthDate = viewModel.birthdate {
        BoldLabel("Birthdate", details: birthDate)
      }
      if let embraceDate = viewModel.embraceDate {
        BoldLabel("Embrace Date", details: embraceDate)
      }
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
