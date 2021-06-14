//
//  ScrollingImageHeaderViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

extension ScrollingImageHeader {
  class ViewModel: ObservableObject {
    
    @Published var fullSizeImageData: [Data]
    @Published var thumbnailImageData: [Data]
    @Published var attemptedToAddDuplicateImage = false
    
    let kindred: Kindred
    let dataController: DataController
    
    init(kindred: Kindred, dataController: DataController) {
      self.kindred = kindred
      self.dataController = dataController
      
      fullSizeImageData = kindred.fullSizeImageData
      thumbnailImageData = kindred.thumbnailImageData
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
      dataController.save()
      
      fullSizeImageData.append(fullSize)
      thumbnailImageData.append(thumbnail)
    }
    
    func removeImage(at index: Int) {
      let images = kindred.images?.allObjects as? [KindredImage] ?? []
      if 0..<images.count ~= index {
        let image = images[index]
        
        kindred.removeFromImages(image)
        dataController.save()
        fullSizeImageData.remove(at: index)
        thumbnailImageData.remove(at: index)
      } else {
        print("Can't delete index \(index).")
      }
    }
    
    private func imageIsDuplicate(_ image: Data) -> Bool {
      let hash = image.hashValue
      let imageHashes = kindred.fullSizeImageData.map { $0.hashValue }
      return imageHashes.contains(hash)
    }
    
  }
}
