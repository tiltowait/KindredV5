//
//  ImageTabs.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

struct ImageTabs: View, Identifiable {
  
  @Environment(\.presentationMode) var presentationMode
  
  @State private var showingDeletionActionSheet = false
  @State private var selectedImageIndex: Int
  
  let imageURLs: [URL]
  let deletionHandler: (Int) -> Void
  let id = UUID()
  
  var images: [Image] {
    self.imageURLs.compactMap({ UIImage(contentsOfFile: $0.path) }).map(Image.init)
  }
  
  init(images: [URL], index: Int, deletionHandler: @escaping (Int) -> Void) {
    self.imageURLs = images
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
          .destructive(Text("Delete Photo")) {
            // We delay the deletion to give us time to dismiss and avoid an index out of range error
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              deletionHandler(selectedImageIndex)
            }
            presentationMode.wrappedValue.dismiss()
          }
        ]
      )
    }
  }
}

//struct ImageTabs_Previews: PreviewProvider {
//  static let images = [Image("nadea"), Image("nadea-portrait")]
//  
//  static var previews: some View {
//    ImageTabs(images: images, index: 0) { _ in }
//  }
//}
