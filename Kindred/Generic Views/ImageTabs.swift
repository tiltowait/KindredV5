//
//  ImageTabs.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

struct ImageTabs: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  @State private var showingDeletionActionSheet = false
  @State private var selectedImageIndex: Int
  
  let images: [Image]
  let deletionHandler: (Int) -> Void
  
  init(images: [Image], index: Int, deletionHandler: @escaping (Int) -> Void) {
    self.images = images
    _selectedImageIndex = State(wrappedValue: index)
    self.deletionHandler = deletionHandler
    
    UIToolbar.appearance().barTintColor = .black // No way to change this natively in SwiftUI
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        
        TabView(selection: $selectedImageIndex) {
          ForEach(0..<images.count) { index in
            images[index]
              .resizable()
              .scaledToFit()
          }
        }
        .tabViewStyle(.page)
      }
      .toolbar {
        ToolbarItem(placement: .bottomBar) {
          Spacer()
        }
        
        ToolbarItem(placement: .bottomBar) {
          Button {
            showingDeletionActionSheet = true
          } label: {
            Label("Delete", systemImage: "trash")
          }
        }
      }
    }
    .actionSheet(isPresented: $showingDeletionActionSheet) {
      ActionSheet(
        title: Text(""),
        message: Text("This photo will not be deleted from your photos library."),
        buttons: [
          .cancel(),
          .destructive(Text("Delete Photo"), action: {
            deletionHandler(selectedImageIndex)
            presentationMode.wrappedValue.dismiss()
          })
        ]
      )
    }
  }
}

struct ImageTabs_Previews: PreviewProvider {
  static let images = [Image("nadea"), Image("nadea-portrait")]
  
  static var previews: some View {
    ImageTabs(images: images, index: 0) { _ in }
  }
}
