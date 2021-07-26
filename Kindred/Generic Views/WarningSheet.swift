//
//  WarningSheet.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/21/21.
//

import SwiftUI

struct WarningSheet: View, Identifiable {
  
  @Environment(\.presentationMode) var presentationMode
  var id = UUID()
  
  var title: LocalizedStringKey = "Warning"
  let message: String
  let warnings: [String: [String]]
  let dismissHandler: () -> ()
  
  var body: some View {
    NavigationView {
      ZStack(alignment: .bottom) {
        Image(systemName: "exclamationmark.triangle")
          .resizable()
          .scaledToFit()
          .frame(width: 200)
          .padding(.bottom, 30)
          .foregroundColor(.yellow)
          .opacity(0.15)
        
        ScrollView {
          VStack(alignment: .leading) {
            HStack {
              Text(message)
              Spacer()
            }
            Divider()
            formattedWarnings()
          }
          .padding()
          .multilineTextAlignment(.leading)
        }
        .navigationBarTitle(title, displayMode: .inline)
        .toolbar {
          ToolbarItem(placement: .confirmationAction) {
            Button("Close", action: dismiss)
          }
        }
      }
    }
  }
  
  func formattedWarnings() -> some View {
    ForEach(Array(warnings.keys)) { key in
      Text(key)
        .bold()
      Text(warnings[key]!.joined(separator: ", "))
        .padding(.bottom)
    }
  }
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
    dismissHandler()
  }
  
}

struct WarningSheet_Previews: PreviewProvider {
  static var previews: some View {
    WarningSheet(
      message: "People eye.",
      warnings: ["Aardvarks": ["One", "Two", "Three"]]
    ) { /* Do nothing */ }
  }
}
