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
  @State private var addedImage: UIImage?
  
  @State private var showingImageIndex: Int?
  
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
              .frame(height: 100)
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
      ImagePicker(image: $addedImage)
    }
    .sheet(item: $showingImageIndex) { index in
      ImageView(image: fullSizeImages[index], deletionHandler: viewModel.removeImage)
    }
    .alert(isPresented: $viewModel.attemptedToAddDuplicateImage) {
      Alert(
        title: Text("Duplicate Image"),
        message: Text("This image has already been added. Skipping."),
        dismissButton: nil
      )
    }
  }
  
  func addImage() {
    if let image = addedImage {
      // Before we add the image, we have to generate the new thumbnail
      
      // Get the new size
      let targetHeight: CGFloat = 100
      let ratio = targetHeight / image.size.height
      let targetWidth = image.size.width * ratio
      
      let newSize = CGSize(width: targetWidth, height: targetHeight)
      let rect = CGRect(origin: .zero, size: newSize)
      
      // Draw the resized UIImage
      let renderer = UIGraphicsImageRenderer(size: newSize)
      let scaledImage = renderer.image { _ in
        image.draw(in: rect)
      }
      
      // Generate the data
      guard let fullSize = image.pngData(),
            let thumbnail = scaledImage.pngData()
      else { return }

      viewModel.addImage(fullSize: fullSize, thumbnail: thumbnail)
    }
  }
}

//struct ScrollingImageHeader_Previews: PreviewProvider {
//  static var previews: some View {
//    ScrollingImageHeader(imageData: [], completionHandler: nil)
//  }
//}
