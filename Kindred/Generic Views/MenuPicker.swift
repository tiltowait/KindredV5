//
//  MenuPicker.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/13/21.
//
//  Modified from https://gist.github.com/imthath-m/469cee5dde579d7892e4233811f7b17c on 7/13/21.

import SwiftUI

@available (iOS 14.0, *)
public struct MenuPicker<T: CustomStringConvertible & Hashable, V: View>: View {
  
  @Binding var selected: Int
  var array: [T]
  var title: String?
  let mapping: (T) -> V
  
  public init(selected: Binding<Int>, array: [T], title: String? = nil,
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
      ForEach(array.indices, id: \.self) { index in
        Button(action: {
          selected = index
        }, label: {
          view(for: index)
        })
      }
    }, label: {
      mapping(array[selected])
    })
  }
  
  @ViewBuilder func view(for index: Int) -> some View {
    if selected == index {
      Label(array[index].description, systemImage: "checkmark")
//      HStack {
//        Image(systemName: "checkmark")
//        Text(array[index].description)
//      }
    } else {
      Text(array[index].description)
    }
  }
  
}
