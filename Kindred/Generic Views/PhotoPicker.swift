//
//  PhotoPicker.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/28/21.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct PhotoPicker: UIViewControllerRepresentable {
  
  let imageHandler: (UIImage) -> Void
  let errorHandler: ((String) -> Void)?
  
  func makeUIViewController(context: Context) -> some UIViewController {
    var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
    configuration.filter = .images
    configuration.selectionLimit = 1
    configuration.preferredAssetRepresentationMode = .current
    
    let photoPickerViewController = PHPickerViewController(configuration: configuration)
    photoPickerViewController.delegate = context.coordinator
    return photoPickerViewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    // Intentionally left empty
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
}

extension PhotoPicker {
  class Coordinator: PHPickerViewControllerDelegate {
    
    private let parent: PhotoPicker
    
    init(_ parent: PhotoPicker) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      defer { picker.dismiss(animated: true) }
      guard let result = results.first else { return }
      
      result.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
        if let data = data {
          if let image = UIImage(data: data) {
            self.parent.imageHandler(image)
          } else {
            self.parent.errorHandler?("Unable to load the image.")
          }
        } else {
          self.parent.errorHandler?("Unable to locate the image.")
        }
      }
    }
    
  }
  
}
