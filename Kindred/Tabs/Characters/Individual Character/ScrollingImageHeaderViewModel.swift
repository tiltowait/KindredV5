//
//  ScrollingImageHeaderViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import UIKit

extension ScrollingImageHeader {
  class ViewModel: BaseSavingKindredViewModel {
    
    @Published var fullsizeImages: [UIImage]
    @Published var thumbnailImages: [UIImage]
    @Published var attemptedToAddDuplicateImage = false
    
    override init(kindred: Kindred, dataController: DataController) {
      self.fullsizeImages = kindred.fullsizeImages.compactMap { UIImage(data: $0) }
      self.thumbnailImages = kindred.thumbnailImages.compactMap { UIImage(data: $0) }
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    func addImage(fullsize: UIImage, thumbnail: UIImage) {
      guard let fullsizeData = fullsize.jpegData(compressionQuality: 0.8),
            let thumbnailData = thumbnail.jpegData(compressionQuality: 0.7)
      else { return }
      
      if imageIsDuplicate(fullsizeData) {
        attemptedToAddDuplicateImage = true
      } else {
        let kindredImage = KindredImage(context: dataController.container.viewContext)
        
        kindredImage.fullsize = fullsizeData
        kindredImage.thumbnail = thumbnailData
        kindredImage.creationDate = Date()
        
        kindred.addToImages(kindredImage)
        
        fullsizeImages.append(fullsize)
        thumbnailImages.append(thumbnail)
        
        save()
      }
    }
    
    func removeImage(at index: Int) {
      let images = kindred.allImageObjects
      
      if 0..<images.count ~= index {
        objectWillChange.send()
        let image = images[index]
        
        kindred.removeFromImages(image)
        dataController.delete(image)
        
        // Remove the image from the header
        fullsizeImages.remove(at: index)
        thumbnailImages.remove(at: index)
        
        save()
      }
    }
    
    func imageIsDuplicate(_ image: Data) -> Bool {
      let hashes = kindred.fullsizeImages.map(\.hashValue)
      return hashes.contains(image.hashValue)
    }
    
  }
}
