//
//  ScrollingImageHeader.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

extension Int: Identifiable {
  public var id: Int { self }
}

struct ScrollingImageHeader: View {
  
  @StateObject var viewModel: ViewModel
  
  @State private var showingImagePicker = false
  @State private var imageToAdd: UIImage?
  
  @State private var showingImageIndex: Int?
  
  let thumbnailHeight: CGFloat = 100
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var thumbnails: [Image] {
    let images = viewModel.thumbnailImageData.compactMap { UIImage(data: $0) }
    return images.map { Image(uiImage: $0) }
  }
  
  var fullSizeImages: [Image] {
    let images = viewModel.fullSizeImageData.compactMap { UIImage(data: $0) }
    return images.map { Image(uiImage: $0) }
  }
  
  var addImageButton: some View {
    Image(systemName: "photo")
      .resizable()
      .scaledToFit()
      .frame(width: 30)
  }
  
  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(thumbnails.indices) { index in
          Button {
            showingImageIndex = index
          } label: {
            thumbnails[index]
              .resizable()
              .scaledToFit()
              .cornerRadius(10)
              .frame(height: thumbnailHeight)
          }
        }
        .id(UUID())
        
        Button {
          showingImagePicker.toggle()
        } label: {
          addImageButton
        }
      }
    }
    .sheet(isPresented: $showingImagePicker, onDismiss: addImage) {
      ImagePicker(image: $imageToAdd)
    }
    .sheet(item: $showingImageIndex) { index in
      ImageView(
        images: fullSizeImages,
        index: index,
        deletionHandler: viewModel.removeImage
      )
    }
    .alert(isPresented: $viewModel.attemptedToAddDuplicateImage) {
      Alert(
        title: Text("Duplicate Image"),
        message: Text("This image has already been added. Skipping."),
        dismissButton: nil
      )
    }
    .onDisappear(perform: viewModel.save)
  }
  
  /// Adds the selected image to the view model.
  func addImage() {
    if let image = imageToAdd {
      let scaledImage = image.resize(height: thumbnailHeight)
      
      // Theoretically, we should present an alert to the user; however, under no
      // normal circumstances should this fail. In the event we ever start picking
      // images from outside the photo library, we will revisit this topic.
      guard let fullSize = image.pngData(),
            let thumbnail = scaledImage.pngData()
      else { return }

      viewModel.addImage(fullSize: fullSize, thumbnail: thumbnail)
    }
  }
}

struct ScrollingImageHeader_Previews: PreviewProvider {
  static var previews: some View {
    ScrollingImageHeader(kindred: Kindred.example, dataController: DataController.preview)
      .padding()
  }
}
