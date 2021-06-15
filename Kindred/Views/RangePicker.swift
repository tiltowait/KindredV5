//
//  NumberPicker.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI

struct RangePicker: View {
  
  let title: String
  @Binding var selection: Int16
  let range: [Int]
  
  init(_ label: String, selection: Binding<Int16>, range: ClosedRange<Int>) {
    self.title = label
    self._selection = selection
    self.range = Array(range)
  }
  
  var label: Text {
    Text("\(title):")
      .bold()
  }
  
  var body: some View {
    Picker(selection: $selection, label: label) {
      Text("N/A").tag(Int16(-1))
      ForEach(range) { item in
        Text("\(item)").tag(Int16(item))
      }
    }
  }
}

struct NumberPicker_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      RangePicker("Generation", selection: .constant(4), range: 4...16)
    }
  }
}
