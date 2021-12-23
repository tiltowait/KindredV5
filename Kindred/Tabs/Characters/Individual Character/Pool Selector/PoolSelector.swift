//
//  PoolSelector.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI

struct PoolSelector: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @StateObject var viewModel: ViewModel
  @State private var diceRoller: DiceRoller?
  
  init(kindred: Kindred) {
    let viewModel = ViewModel(kindred: kindred)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var selectedTraits: some View {
    VStack {
      if viewModel.selectedTraits.isEmpty {
        HStack {
          Text("Nothing selected")
            .foregroundColor(.secondary)
          Spacer()
        }
      } else {
        HStack {
          ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { reader in
              HStack(spacing: 3) {
                ForEach(viewModel.selectedTraits) { trait in
                  Button(trait) {
                    withAnimation(.easeOut(duration: 0.25)) {
                      viewModel.deselectTrait(trait)
                    }
                  }
                  .padding(.vertical, 4)
                  .padding(.horizontal, 8)
                  .background(
                    RoundedRectangle(cornerRadius: 25)
                      .fill(Color(UIColor.quaternarySystemFill))
                  )
                  .id(trait)
                }
              }
              .onChange(of: viewModel.selectedTraits.count) { _ in
                withAnimation(.easeInOut(duration: 0.01)) {
                  reader.scrollTo(viewModel.selectedTraits.last)
                }
              }
            }
          }
          .padding(.trailing, 5)
          
          Button("Roll \(viewModel.pool)", action: roll)
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 3)
            .background(
              RoundedRectangle(cornerRadius: 7)
                .fill(.blue)
                .shadow(radius: 3)
            )
        }
        Divider()
        
        TrackerStepper("Bonus dice:",
                       value: $viewModel.bonusDice,
                       in: 0...Int16.max
        ) {
          viewModel.pool += 1
        } onDecrement: {
          viewModel.pool -= 1
        }
      }
    }
    .inset()
    .padding(.bottom, -20)
  }
  
  var body: some View {
    NavigationView {
      VStack {
        selectedTraits
        
        ScrollView {
          VStack(spacing: 20) {
            PhonyDisclosureGroup(
              label: "Attributes",
              selection: $viewModel.selectedTraits,
              isExpanded: $viewModel.showingAttributes,
              columns: viewModel.attributeColumns,
              handler: toggleAttribute
            )
            
            Divider()
            
            PhonyDisclosureGroup(
              label: "Skills",
              selection: $viewModel.selectedTraits,
              isExpanded: $viewModel.showingSkills,
              columns: viewModel.skillColumns,
              handler: toggleSkill
            )
            
            if !viewModel.disciplineColumns.isEmpty {
              Divider()
              
              PhonyDisclosureGroup(
                label: "Disciplines",
                selection: $viewModel.selectedTraits,
                isExpanded: $viewModel.showingDisciplines, columns: viewModel.disciplineColumns,
                handler: toggleSkill
              )
            }
          }
          .inset()
        }
        .navigationBarTitle("Select Pool", displayMode: .inline)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Close", action: dismiss)
          }
          
          ToolbarItem(placement: .primaryAction) {
            Button("Reset", action: clearAll)
              .accentColor(.red)
          }
        }
      }
      .background(Color.tertiarySystemGroupedBackground)
    }
    .sheet(item: $diceRoller) { roller in
      NavigationView {
        roller
          .navigationBarTitle("Dice Roll", displayMode: .inline)
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Close") { diceRoller = nil }
            }
          }
      }
    }
  }
  
  func roll() {
    diceRoller = DiceRoller(
      pool: viewModel.pool,
      hunger: viewModel.hunger
    )
  }
  
  func toggleAttribute(_ attribute: String) {
    withAnimation {
      viewModel.toggleAttribute(attribute)
    }
  }
  
  func toggleSkill(_ skill: String) {
    withAnimation {
      viewModel.toggleSkill(skill)
    }
  }
  
  func clearAll() {
    withAnimation {
      viewModel.reset()
    }
  }
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
  
}

fileprivate struct PhonyDisclosureGroup: View {
  
  let label: LocalizedStringKey
  @Binding var selection: [String]
  @Binding var isExpanded: Bool
  let columns: [[String]]
  let handler: (String) -> ()
  
  var body: some View {
    VStack(alignment: .leading) {
      Button {
        withAnimation(.easeInOut(duration: 0.25)) {
          isExpanded.toggle()
        }
      } label: {
        Text(label)
          .bold()
        Spacer()
        Image(systemName: "chevron.right")
          .rotationEffect(isExpanded ? Angle(degrees: 90) : .zero)
          .foregroundColor(.blue)
      }
      .contentShape(Rectangle())
      .buttonStyle(.plain)
      
      if isExpanded {
        ButtonPad(
          selection: $selection,
          columns: columns,
          perform: handler
        )
        .padding(.top)
        .transition(
          .asymmetric(
            insertion: .opacity.animation(.easeInOut.delay(0.2)),
            removal: .opacity.animation(.easeInOut(duration: 0.1))
          )
        )
      }
    }
  }
  
}

fileprivate extension VStack {
  
  /// Inset the VStack inside a rounded rect. Can mimic the appearance
  /// of InsetGroupedListStyle.
  /// - Returns: The inset VStack.
  func inset() -> some View {
    self
      .padding(.vertical, 10)
      .padding(.horizontal, 20)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(Color.systemBackground)
      )
      .padding()
  }
  
}

#if DEBUG
struct DiceRollView_Previews: PreviewProvider {
  static var previews: some View {
    PoolSelector(kindred: Kindred.example)
  }
}
#endif
