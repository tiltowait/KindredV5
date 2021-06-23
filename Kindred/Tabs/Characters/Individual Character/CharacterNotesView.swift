//
//  CharacterNotesView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/22/21.
//

import SwiftUI
import TextView

struct CharacterNotesView: View {
  
  let kindred: Kindred
  @State private var notes: String
  @State private var isEditing = false
  
  init(kindred: Kindred) {
    self.kindred = kindred
    notes = kindred.notes
  }
  
  var body: some View {
    NavigationView {
      TextView(
        text: $notes,
        isEditing: $isEditing,
        placeholder: "Enter your notes for \(kindred.name) ..."
      )
      .padding()
      .navigationBarTitle("Notes", displayMode: .inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Done", action: saveAndDismiss)
        }
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", action: cancel)
        }
      }
    }
  }
  
  func cancel() {
    isEditing = false
    UIViewController.root?.dismiss(animated: true)
  }
  
  func saveAndDismiss() {
    kindred.notes = self.notes
    isEditing = false
    UIViewController.root?.dismiss(animated: true)
  }
  
}

#if DEBUG
struct CharacterNotesView_Previews: PreviewProvider {
  static var previews: some View {
    CharacterNotesView(kindred: Kindred.example)
  }
}
#endif
