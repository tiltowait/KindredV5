//
//  ImageView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

struct ImageView: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @State private var showingDeletionAlert = false
  
  let images: [Image]
  @State private var index: Int
  let deletionHandler: (Int) -> Void
  
  init(images: [Image], index: Int, deletionHandler: @escaping (Int) -> Void) {
    self.images = images
    _index = State(wrappedValue: index)
    self.deletionHandler = deletionHandler
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.black
          .edgesIgnoringSafeArea(.all)
        images[index]
          .resizable()
          .scaledToFit()
      }
      .toolbar {
        Button {
          showingDeletionAlert = true
        } label: {
          Label("Delete", systemImage: "trash")
        }
      }
    }
    .accentColor(.red)
    .alert(isPresented: $showingDeletionAlert) {
      Alert(
        title: Text("Delete this photo?"),
        primaryButton: .cancel(),
        secondaryButton: .destructive(Text("Delete"), action: {
          deletionHandler(index)
          presentationMode.wrappedValue.dismiss()
        })
      )
    }
  }
}

//struct ImageView_Previews: PreviewProvider {
//  static var previews: some View {
//    ImageView(image: Image(systemName: "person.circle.fill"))
//  }
//}
