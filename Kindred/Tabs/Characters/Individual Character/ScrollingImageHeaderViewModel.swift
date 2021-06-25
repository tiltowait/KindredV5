//
//  ScrollingImageHeaderViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

extension ScrollingImageHeader {
  class ViewModel: BaseSavingKindredViewModel {
    
    @Published var fullSizeImageData: [Data]
    @Published var thumbnailImageData: [Data]
    @Published var attemptedToAddDuplicateImage = false
    
    override init(kindred: Kindred, dataController: DataController) {
      fullSizeImageData = kindred.fullSizeImageData
      thumbnailImageData = kindred.thumbnailImageData
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    func addImage(fullSize: Data, thumbnail: Data) {
      if imageIsDuplicate(fullSize) {
        attemptedToAddDuplicateImage.toggle()
        return
      }
      
      let kindredImage = KindredImage(context: dataController.container.viewContext)
      kindredImage.image = fullSize
      kindredImage.thumb = thumbnail
      kindredImage.creationDate = Date()
      
      kindred.addToImages(kindredImage)
      
      fullSizeImageData.append(fullSize)
      thumbnailImageData.append(thumbnail)
    }
    
    func removeImage(at index: Int) {
      let images = kindred.allImageObjects
      if 0..<images.count ~= index {
        let image = images[index]
        
        kindred.removeFromImages(image)
        dataController.delete(image)
        fullSizeImageData.remove(at: index)
        thumbnailImageData.remove(at: index)
      }
    }
    
    private func imageIsDuplicate(_ image: Data) -> Bool {
      let hash = image.hashValue
      let imageHashes = kindred.fullSizeImageData.map { $0.hashValue }
      return imageHashes.contains(hash)
    }
    
  }
}
