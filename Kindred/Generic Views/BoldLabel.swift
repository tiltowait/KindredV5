//
//  BoldLabel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

/// A `View` with a bold label and regular "details" text.
struct BoldLabel: View {
  
  /// Defines the layout method of the label.
  enum Layout {
    /// "Label, Details" with no spacing, both in the
    ///  primary color.
    case standard
    
    /// "Label, -spacer-, Details", with details in the
    /// secondary color.
    case picker
  }
  
  let label: LocalizedStringKey
  let details: String
  let layout: Layout
  
  init(
    _ label: LocalizedStringKey,
    details: String,
    layout: Layout = .standard
  ) {
    self.label = label
    self.details = details
    self.layout = layout
  }
  
  init(
    _ label: LocalizedStringKey,
    details: Int,
    layout: Layout = .standard
  ) {
    self.init(label, details: String(details), layout: layout)
  }
  
  var body: some View {
    HStack(alignment: .top) {
      Text(label)
        .bold()
      
      if layout == .standard {
        Text(details)
      } else {
        Spacer()
        Text(details)
          .foregroundColor(.secondary)
      }
    }
  }
  
}

struct BoldLabel_Previews: PreviewProvider {
  static var previews: some View {
    BoldLabel("Strength:", details: 3)
      .previewLayout(.sizeThatFits)
  }
}
