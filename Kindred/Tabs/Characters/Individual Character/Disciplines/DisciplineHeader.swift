//
//  DisciplineHeader.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct DisciplineHeader: View {
  
  let title: String
  @Binding var buttonPressed: Bool
  
  init(_ title: String, buttonPressed: Binding<Bool>) {
    self.title = title
    _buttonPressed = buttonPressed
  }
  
  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Button {
        buttonPressed.toggle()
      } label: {
        Label("Add \(title)", systemImage: "plus.circle")
          .labelStyle(.iconOnly)
      }
    }
  }
}

struct AdvantageHeader_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        Section(header: DisciplineHeader("Disciplines", buttonPressed: .constant(false))) {
          Text("Stuff goes here")
        }
        .navigationTitle("Nadea Theron")
      }
      .listStyle(.grouped)
    }
  }
}
