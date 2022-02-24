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
  @State private var showingImageIndex: Int?
  @State private var imagePickerError: String?
  
  let thumbnailHeight: CGFloat = 100
  
  init(kindred: Kindred, dataController: DataController) {
    let viewModel = ViewModel(kindred: kindred, dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var thumbnails: [Image] {
    let images = viewModel.thumbnailImages.compactMap { UIImage(contentsOfFile: $0.path) }
    return images.map { Image(uiImage: $0) }
  }
  
  var fullSizeImages: [Image] {
    let images = viewModel.fullsizeImages.compactMap { UIImage(contentsOfFile: $0.path) }
    return images.map { Image(uiImage: $0) }
  }
  
  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack {
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
          Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: 30)
        }
      }
      .sheet(isPresented: $showingImagePicker) {
        PhotoPicker(imageHandler: addImage, errorHandler: imageError)
      }
    }
    .sheet(item: $showingImageIndex) { index in
      ImageTabs(
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
    .alert(item: $imagePickerError) { error in
      Alert(
        title: Text("Unable to Load"),
        message: Text(error),
        dismissButton: nil
      )
    }
    .onDisappear(perform: viewModel.save)
  }
  
  /// Adds the selected image to the view model.
  func addImage(_ image: UIImage) {
    DispatchQueue.main.async {
      let scaledImage = image.resize(height: thumbnailHeight)
      
      // Theoretically, we should present an alert to the user;
      // however, under no normal circumstances should this fail. In
      // the event we ever start picking images from outside the
      // photo library, we will revisit this topic.
      guard let fullSize = image.pngData(),
            let thumbnail = scaledImage.pngData()
      else { return }
      
      viewModel.addImage(fullSize: fullSize, thumbnail: thumbnail)
    }
  }
  
  func imageError(_ error: String) {
    imagePickerError = error
  }
  
}

#if DEBUG
struct ScrollingImageHeader_Previews: PreviewProvider {
  static var previews: some View {
    ScrollingImageHeader(kindred: Kindred.example, dataController: DataController.preview)
      .padding()
  }
}
#endif
