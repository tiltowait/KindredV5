//
//  ScrollingImageHeaderViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import UIKit

extension ScrollingImageHeader {
  class ViewModel: BaseSavingKindredViewModel {
    
    @Published var fullsizeImages: [URL]
    @Published var thumbnailImages: [URL]
    @Published var attemptedToAddDuplicateImage = false
    
    override init(kindred: Kindred, dataController: DataController) {
      fullsizeImages = kindred.fullsizeImageURLs
      thumbnailImages = kindred.thumbnailImageURLs
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    func addImage(fullSize: Data, thumbnail: Data) {
      if imageIsDuplicate(fullSize) {
        attemptedToAddDuplicateImage.toggle()
        return
      }
      
      let kindredImage = KindredImage(context: dataController.container.viewContext)
      let fullsizeURL = URL.documents.appendingPathComponent("\(UUID()).png")
      let thumbnailURL = URL.documents.appendingPathComponent("\(UUID()).png")
      
      do {
        try fullSize.write(to: fullsizeURL)
        try thumbnail.write(to: thumbnailURL)
      } catch {
        fatalError("Unable to write image: \(error.localizedDescription)")
      }
      
      kindredImage.imageURL = fullsizeURL
      kindredImage.thumbnailURL = thumbnailURL
      kindredImage.creationDate = Date()
      
      kindred.addToImages(kindredImage)
      
      fullsizeImages.append(fullsizeURL)
      thumbnailImages.append(thumbnailURL)
      save()
    }
    
    func removeImage(at index: Int) {
      let images = kindred.allImageObjects
      
      if 0..<images.count ~= index {
        objectWillChange.send()
        let image = images[index]
        
        kindred.removeFromImages(image)
        dataController.delete(image)
        
        // Remove the image from the file system
        let fullsizePath = fullsizeImages.remove(at: index)
        let thumbnailPath = thumbnailImages.remove(at: index)
        
        do {
          try FileManager.default.removeItem(at: fullsizePath)
          try FileManager.default.removeItem(at: thumbnailPath)
        } catch {
          print("Unable to delete image: \(error.localizedDescription)")
        }
        save()
      }
    }
    
    private func imageIsDuplicate(_ image: Data) -> Bool {
      let hashes = kindred.fullsizeImageURLs.compactMap { try? Data(contentsOf: $0).hashValue }
      return hashes.contains(image.hashValue)
    }
    
  }
}
