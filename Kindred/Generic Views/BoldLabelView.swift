//
//  BoldLabelView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

/// A `View` with a bold label and regular "details" text.
struct BoldLabelView: View {
  
  let label: String
  let details: String
  
  init(_ label: String, details: String) {
    self.label = label
    self.details = details
  }
  
  init(_ label: String, details: Int) {
    self.init(label, details: String(details))
  }
  
  var body: some View {
    HStack(alignment: .top) {
      Text("\(label):")
        .bold()
      Text(details)
    }
  }
  
}

struct BoldLabelView_Previews: PreviewProvider {
  static var previews: some View {
    BoldLabelView("Strength", details: 3)
      .previewLayout(.sizeThatFits)
  }
}
