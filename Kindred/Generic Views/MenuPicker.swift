//
//  MenuPicker.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/13/21.
//
//  Modified from https://gist.github.com/imthath-m/469cee5dde579d7892e4233811f7b17c on 7/13/21.

import SwiftUI

@available (iOS 14.0, *)
public struct MenuPicker<T: CustomStringConvertible & Hashable & Identifiable, V: View>: View {
  
  @Binding var selected: T
  var array: [T]
  var title: String?
  let mapping: (T) -> V
  
  public init(selected: Binding<T>, array: [T], title: String? = nil,
              mapping: @escaping (T) -> V) {
    self._selected = selected
    self.array = array
    self.title = title
    self.mapping = mapping
  }
  
  public var body: some View {
    if let existingTitle = title {
      HStack {
        Text(existingTitle)
          .foregroundColor(.primary)
          .padding(.horizontal)
        menu
      }
    } else {
      menu
    }
  }
  
  var menu: some View {
    Menu(content: {
      ForEach(array) { element in
        Button(action: {
          selected = element
        }, label: {
          view(for: element)
        })
      }
    }, label: {
      mapping(selected)
    })
  }
  
  @ViewBuilder func view(for element: T) -> some View {
    if selected == element {
      Label(element.description, systemImage: "checkmark")
    } else {
      Text(element.description)
    }
  }
  
}
