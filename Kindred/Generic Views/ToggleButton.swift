//
//  ToggleButton.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI

struct ToggleButton: View {
  
  @Binding var isToggled: Bool
  
  let cornerRadius: CGFloat = 7
  
  var backgroundColor: Color {
    isToggled ? Color.red : Color.clear
  }
  
  var strokeColor: Color {
    isToggled ? Color.red : Color.primary
  }
  
  var fontColor: Color {
    isToggled ? Color.white : Color.primary
  }
  
  let label: String
  let perform: (String) -> Void
  
  var body: some View {
    Button {
      perform(label)
    } label: {
      Spacer()
      Text(label)
        .font(.callout)
      Spacer()
    }
    .frame(minHeight: 20)
    .padding(.vertical, 5)
    .minimumScaleFactor(0.01)
    .lineLimit(1)
    .background(
      ZStack {
        RoundedRectangle(cornerRadius: cornerRadius)
          .strokeBorder(strokeColor, lineWidth: 2)
          .opacity(0.5)
        RoundedRectangle(cornerRadius: cornerRadius)
          .fill(backgroundColor)
      }
    )
    .foregroundColor(fontColor)
  }
}

struct ToggleButton_Previews: PreviewProvider {
  static var previews: some View {
    ToggleButton(isToggled: .constant(true), label: "Animal Ken") { _ in }
      .previewLayout(.sizeThatFits)
  }
}
