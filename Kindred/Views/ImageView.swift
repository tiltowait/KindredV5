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
  @State private var selectedImageIndex: Int
  
  let images: [Image]
  let deletionHandler: (Int) -> Void
  
  init(images: [Image], index: Int, deletionHandler: @escaping (Int) -> Void) {
    self.images = images
    _selectedImageIndex = State(wrappedValue: index)
    self.deletionHandler = deletionHandler
    
    UIToolbar.appearance().barTintColor = .black
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        
        TabView(selection: $selectedImageIndex) {
          ForEach(0..<images.count, id: \.self) { index in
            images[index]
              .resizable()
              .scaledToFit()
          }
        }
        .tabViewStyle(PageTabViewStyle())
      }
      .toolbar {
        ToolbarItem(placement: .bottomBar) {
          Spacer()
        }
        
        ToolbarItem(placement: .bottomBar) {
          Button {
            showingDeletionAlert = true
          } label: {
            Label("Delete", systemImage: "trash")
          }
        }
      }
    }
    .alert(isPresented: $showingDeletionAlert) {
      Alert(
        title: Text("Delete this photo?"),
        primaryButton: .cancel(),
        secondaryButton: .destructive(Text("Delete"), action: {
          deletionHandler(selectedImageIndex)
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
