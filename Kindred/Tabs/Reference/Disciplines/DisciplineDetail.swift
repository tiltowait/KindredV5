//
//  DisciplineDetail.swift
//  Kindred
//
//  Created by Jared Lindsay on 5/21/21.
//

import SwiftUI

struct DisciplineDetail: View {
  
  @Environment(\.viewController) var viewController
  
  let discipline: Discipline
  
  var body: some View {
    List {
      Section(
        header: Text(discipline.info),
        footer: IconFooter(icon: discipline.icon)
      ) {
        ForEach(discipline.allPowers) { power in
          Button {
            show(power: power)
          } label: {
            PowerRow(power: power)
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
    }
    .listStyle(GroupedListStyle())
    .navigationTitle(discipline.name)
  }
  
  /// Display a power's details in a custom alert.
  /// - Parameter power: The power to display.
  func show(power: Power) {
    viewController?.present {
      PowerCard(power: power)
    }
  }
  
}

struct DisciplineDetail_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DisciplineDetail(discipline: Discipline.example)
    }
  }
}
