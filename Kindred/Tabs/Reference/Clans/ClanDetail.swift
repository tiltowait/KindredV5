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
  
  /// Create a new clan detail view.
  /// - Parameters:
  ///   - clan: The clan to display.
  ///   - kindred: Optionally, a Kindred to which to apply a clan.
  ///   - reselection: Optionally, a completion handler for showing the clan selection sheet.
  init(clan: Clan, kindred: Kindred? = nil, reselection: (() -> Void)? = nil) {
    let viewModel = ViewModel(clan: clan, kindred: kindred, reselection: reselection)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  @ViewBuilder var selectionButton: some View {
    if viewModel.selectButtonVisible {
      Button("Select Clan", action: selectClan)
    } else if viewModel.reselectButtonVisible {
      Button("Change Clan", action: viewModel.reselection!)
    }
  }
  
  var body: some View {
    ZStack {
      // Not using alignment: .bottom, because it doesn't
      // guarantee the views will be pinned to the bottom
      // of the screen, only the parent container.
      VStack {
        Spacer()
        Image(viewModel.clan.icon)
          .resizable()
          .scaledToFit()
          .frame(maxWidth: 300)
          .opacity(0.1)
          .accessibilityHidden(true)
      }
      .padding(.bottom)
      
      ScrollView {
        // Embedding the content within a group so we can apply
        // padding without interfering with the scroll indicators
        // or affecting clipping areas.
        Group {
          VStack {
            Image(viewModel.clan.header)
              .resizable()
              .scaledToFit()
              .frame(maxWidth: 400)
            
            Text(viewModel.clan.pageReference)
              .font(.subheadline)
              .foregroundColor(.secondary)
              .italic()
          }
          .accessibilityElement(children: .combine)
          .accessibilityLabel(Text("\(viewModel.clan.name), from \(viewModel.clan.pageReference)"))
          
          Divider()
          
          Text(viewModel.clan.info)
            .lineLimitFix()
          
          if !viewModel.clan.inClanDisciplines.isEmpty {
            Divider()
            HStack {
              Spacer()
              ForEach(viewModel.clan.inClanDisciplines) { discipline in
                disciplineBox(discipline)
                Spacer()
              }
            }
          }
          
          if let bane = viewModel.clan.bane {
            Divider()
            infoBox("Bane:", contents: bane)
          }
          if let compulsion = viewModel.clan.compulsion {
            Divider()
            infoBox("Compulsion: \(compulsion)", contents: viewModel.clan.compulsionDetails!)
          }
        }
        .padding()
      }
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      selectionButton
    }
    .sheet(item: $selectedDiscipline, content: disciplineSheet)
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
    .buttonStyle(.plain)
  }
  
  func infoBox(_ title: String, contents: String) -> some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(title)
        .font(.system(size: 20, weight: .heavy, design: .serif))
        .foregroundColor(.vampireRed)
      Text(contents)
        .fixedSize(horizontal: false, vertical: true)
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel(Text("\(title): \(contents)"))
  }
  
  func disciplineSheet(_ discipline: Discipline) -> some View {
    NavigationView {
      DisciplineDetail(discipline: discipline, kindred: nil)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Close") { selectedDiscipline = nil }
          }
        }
    }
  }
  
  func selectClan() {
    viewModel.selectClan()
    // This is being displayed in a sheet, so all we have to do is pop it off
    UIViewController.topMost?.dismiss(animated: true)
  }
  
}

#if DEBUG
struct ClanDetail_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ClanDetail(clan: Clan.example, kindred: Kindred.example)
    }
  }
}
#endif

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
