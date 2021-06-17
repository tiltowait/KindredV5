//
//  AdvantageHeader.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/17/21.
//

import SwiftUI

struct AdvantageHeader: View {
  
  let label: LocalizedStringKey
  @Binding var buttonPressed: Bool
  
  init(_ label: LocalizedStringKey, binding: Binding<Bool>) {
    self.label = label
    _buttonPressed = binding
  }
  
  var body: some View {
    HStack {
      Text(label)
      Spacer()
      Button {
        buttonPressed.toggle()
      } label: {
        Image(systemName: "plus.circle")
      }
    }
  }
}

struct AdvantageHeader_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        Section(header: AdvantageHeader("Disciplines", binding: .constant(false))) {
          Text("Stuff goes here")
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Nadea Theron")
      }
      .listStyle(GroupedListStyle())
    }
  }
}
