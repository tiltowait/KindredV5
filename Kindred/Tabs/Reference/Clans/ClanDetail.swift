//
//  ClanDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//

import SwiftUI

struct ClanDetail: View {
  
  @StateObject private var viewModel: ViewModel
  
  @State private var selectedDiscipline: Discipline?
  
  init(clan: Clan, kindred: Kindred? = nil, dataController: DataController? = nil) {
    let viewModel = ViewModel(clan: clan, kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var selectClanButton: some View {
    Group {
      if viewModel.selectButtonVisible {
        Button("Select Clan", action: selectClan)
      }
    }
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      Image(viewModel.clan.icon)
        .resizable()
        .scaledToFit()
        .scaleEffect(0.5)
        .opacity(0.1)
      
      ScrollView {
        // Embedding the content within a group so we can apply
        // padding without interfering with the scroll indicators
        // or affecting clipping areas.
        Group {
          Image(viewModel.clan.header)
            .resizable()
            .scaledToFit()
          
          Text(viewModel.clan.pageReference)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .italic()
          
          Divider()
          
          Text(viewModel.clan.info)
            .lineLimitFix()
          
          Divider()
          
          HStack {
            Spacer()
            ForEach(viewModel.clan.inClanDisciplines) { discipline in
              disciplineBox(discipline)
              Spacer()
            }
          }
          
          Divider()
          
          infoBox("Bane:", contents: viewModel.clan.bane)
          
          Divider()
          
          infoBox("Compulsion: \(viewModel.clan.compulsion)", contents: viewModel.clan.compulsionDetails)
        }
        .padding()
      }
    }
    .sheet(item: $selectedDiscipline, content: disciplineSheet)
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(trailing: selectClanButton)
  }
  
  func disciplineBox(_ discipline: Discipline) -> some View {
    Button {
      selectedDiscipline = discipline
    } label: {
      VStack {
        Image(discipline.icon)
          .resizable()
          .frame(width: 40, height: 40)
        Text(discipline.name)
          .font(.system(size: 14, weight: .heavy, design: .serif).lowercaseSmallCaps())
      }
    }
    .buttonStyle(PlainButtonStyle())
  }
  
  func infoBox(_ title: LocalizedStringKey, contents: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(title)
        .font(.system(size: 20, weight: .heavy, design: .serif))
      Text(contents)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
  
  func disciplineSheet(_ discipline: Discipline) -> some View {
    NavigationView {
      DisciplineDetail(discipline: discipline, kindred: nil)
    }
  }
  
  func selectClan() {
    viewModel.selectClan()
    // This is being displayed in a sheet, so all we have to do is pop it off
    UIViewController.root?.dismiss(animated: true)
  }
  
}

struct ClanDetail_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ClanDetail(clan: Clan.example, kindred: Kindred.example, dataController: DataController.preview)
    }
  }
}

/// A view modifier for fixing line limit issues in ScrollViews.
///
/// [Reference post on StackOverflow.](https://stackoverflow.com/questions/56593120/how-do-you-create-a-multi-line-text-inside-a-scrollview-in-swiftui)
struct LineLimitFix: ViewModifier {
  func body(content: Content) -> some View {
    VStack {
      content
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}

extension View {
  
  /// Apply the ScrollView line limit fix.
  /// - Returns: The fixed content.
  func lineLimitFix() -> some View {
    self.modifier(LineLimitFix())
  }
  
}
