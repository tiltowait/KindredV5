//
//  DisciplineHeader.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct DisciplineHeader: View {
  
  @Binding var buttonPressed: Bool
  
  var body: some View {
    HStack {
      Text("Disciplines")
      Spacer()
      Button {
        buttonPressed.toggle()
      } label: {
        Label("Add Discipline", systemImage: "plus.circle")
          .labelStyle(.iconOnly)
      }
    }
  }
}

struct AdvantageHeader_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        Section(header: DisciplineHeader(buttonPressed: .constant(false))) {
          Text("Stuff goes here")
        }
        .navigationTitle("Nadea Theron")
      }
      .listStyle(.grouped)
    }
  }
}
