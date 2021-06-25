//
//  ReferenceRow.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/19/21.
//

import SwiftUI

struct ReferenceRow: View {
  
  let title: LocalizedStringKey
  let subtitle: LocalizedStringKey?
  let secondary: LocalizedStringKey?
  let icon: Image?
  let color: Color?
  let rounded: Bool
  
  /// Create a reference row.
  /// - Parameters:
  ///   - title: The referenced item's title.
  ///   - subtitle: Extra information about the item.
  ///   - secondary: Tertiary information about the item.
  ///   - icon: An image or icon associated with the item.
  ///   - color: A color accent for context.
  init(
    _ title: LocalizedStringKey,
    subtitle: LocalizedStringKey? = nil,
    secondary: LocalizedStringKey? = nil,
    icon: Image? = nil,
    rounded: Bool = false,
    color: Color? = nil
  ) {
    self.title = title
    self.subtitle = subtitle
    self.secondary = secondary
    self.icon = icon
    self.rounded = rounded
    self.color = color
  }
  
  /// Create a reference row.
  /// - Parameters:
  ///   - title: The referenced item's title.
  ///   - subtitle: Extra information about the item.
  ///   - secondary: Tertiary information about the item.
  ///   - icon: An image or icon associated with the item.
  ///   - color: A color accent for context.
  init(
    _ title: String,
    subtitle: String? = nil,
    secondary: String? = nil,
    icon: Image? = nil,
    rounded: Bool = false,
    color: Color? = nil
  ) {
    let title = LocalizedStringKey(title)
    let subtitle = subtitle != nil ? LocalizedStringKey(subtitle!) : nil
    let secondary = secondary != nil ? LocalizedStringKey(secondary!) : nil
    self.init(title, subtitle: subtitle, secondary: secondary, icon: icon, rounded: rounded, color: color)
  }
  
  var body: some View {
    HStack {
      if let icon = icon {
        icon
          .resizable()
          .scaledToFit()
          .cornerRadius(rounded ? 6 : 0)
          .frame(height: 55)
      }
      VStack(alignment: .leading) {
        Text(title)
          .font(.headline)
        if let subtitle = subtitle {
          Text(subtitle)
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
      }
      Spacer()
      
      if let secondary = secondary {
        Text(secondary)
          .multilineTextAlignment(.trailing)
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
  }
}

#if DEBUG
struct ReferenceRow_Previews: PreviewProvider {
  
  static let icon = Image(uiImage: UIImage(data: KindredImage.examples[0].thumb!)!)
  
  static var previews: some View {
    ReferenceRow(
      "Nadea Theron",
      subtitle: "12th-generation Hecata",
      secondary: "Secondary item",
      icon: icon,
      rounded: true
    )
  }
  
}
#endif
