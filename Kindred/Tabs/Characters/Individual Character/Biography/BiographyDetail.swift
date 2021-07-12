//
//  BiographyDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/12/21.
//

import SwiftUI
import TextView

struct BiographyDetail: View {
  
  @StateObject var viewModel: ViewModel
  
  @State private var isEditingAppearance = false
  @State private var isEditingDistinguishingFeatures = false
  @State private var isEditingHistory = false
  @State private var isEditingPossessions = false
  
  let textViewHeight: CGFloat = 150
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    List {
      Section {
        DatePicker(
          selection: $viewModel.inGameDate,
          displayedComponents: .date
        ) {
          Text("In-game date:")
            .bold()
        }
      }
      
      Section {
        DatePicker(selection: $viewModel.birthdate, displayedComponents: .date) {
          Text("Born:")
            .bold()
        }
        if let transitionTerm = viewModel.transitionTerm {
          DatePicker(
            selection: $viewModel.transitionDate,
            displayedComponents: .date
          ) {
            Text("\(transitionTerm):")
              .bold()
          }
          BoldTextField(viewModel.benefactorTerm, binding: $viewModel.benefactor)
        }
        BoldTextField("Height", binding: $viewModel.height)
        BoldTextField("Weight", binding: $viewModel.weight)
      }
      
      DisclosureGroup {
        BoldLabel("Apparent age:", details: viewModel.apparentAge)
        BoldLabel("True age:", details: viewModel.trueAge)
        TextView(
          text: $viewModel.appearance,
          isEditing: $isEditingAppearance,
          placeholder: "Physical appearance ..."
        )
        .frame(height: textViewHeight)
      } label: {
        Text("Appearance")
          .bold()
      }
      DisclosureGroup {
        TextView(
          text: $viewModel.distinguishingFeatures,
          isEditing: $isEditingDistinguishingFeatures,
          placeholder: "Distinguishing features ..."
        )
        .frame(height: textViewHeight)
      } label: {
        Text("Distinguishing Features")
          .bold()
      }
      DisclosureGroup {
        TextView(
          text: $viewModel.history,
          isEditing: $isEditingHistory,
          placeholder: "History ..."
        )
        .frame(height: textViewHeight)
      } label: {
        Text("History")
          .bold()
      }
      DisclosureGroup {
        TextView(
          text: $viewModel.possessions,
          isEditing: $isEditingPossessions,
          placeholder: "Possessions ..."
        )
        .frame(height: textViewHeight)
      } label: {
        Text("Possessions")
          .bold()
      }
    }
    .listStyle(InsetGroupedListStyle())
    .navigationBarTitle("Biography", displayMode: .inline)
    .onDisappear(perform: viewModel.commitChanges)
  }
}

#if DEBUG
struct BiographyDetail_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      BiographyDetail(kindred: Kindred.example, dataController: DataController.preview)
    }
  }
}
#endif
