//
//  PlainTextHeader.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import SwiftUI

/// Text wrapped in a Section header, size 18, in lowercase.
struct PlainTextHeader: View {
  
  let text: LocalizedStringKey
  let fontSize: CGFloat
  
  init(_ text: LocalizedStringKey, fontSize: CGFloat = 18) {
    self.text = text
    self.fontSize = fontSize
  }
  
  init(_ text: String, fontSize: CGFloat = 18) {
    self.text = LocalizedStringKey(text)
    self.fontSize = fontSize
  }
  
  var header: some View {
    Text(text)
      .font(.system(size: fontSize))
      .centered()
  }
  
  var body: some View {
    Section(header: header) { }
      .textCase(nil)
  }
}

struct PlainTextHeader_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      List {
        PlainTextHeader("This is my header")
        Text("Example text")
      }
      .listStyle(.grouped)
    }
  }
}
