//
//  ScrollingImageHeaderViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import UIKit

extension ScrollingImageHeader {
  class ViewModel: BaseSavingKindredViewModel {
    
    @Published var fullsizeURLs: [URL]
    @Published var thumbnailURLs: [URL]
    @Published var attemptedToAddDuplicateImage = false
    
    override init(kindred: Kindred, dataController: DataController) {
      fullsizeURLs = kindred.fullsizeImageURLs
      thumbnailURLs = kindred.thumbnailImageURLs
      
      super.init(kindred: kindred, dataController: dataController)
    }
    
    func addImage(fullSize: Data, thumbnail: Data) {
      if imageIsDuplicate(fullSize) {
        attemptedToAddDuplicateImage = true
      } else {
        let kindredImage = KindredImage(context: dataController.container.viewContext)
        let fullsizeURL = URL.documents.appendingPathComponent(UUID().uuidString + ".png")
        let thumbnailURL = URL.documents.appendingPathComponent(UUID().uuidString + ".jpg")
        
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
        
        fullsizeURLs.append(fullsizeURL)
        thumbnailURLs.append(thumbnailURL)
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
        
        // Remove the image from the file system
        let fullsizePath = fullsizeURLs.remove(at: index)
        let thumbnailPath = thumbnailURLs.remove(at: index)
        
        do {
          try FileManager.default.removeItem(at: fullsizePath)
          try FileManager.default.removeItem(at: thumbnailPath)
        } catch {
          print("Unable to delete image: \(error.localizedDescription)")
        }
        save()
      }
    }
    
    func imageIsDuplicate(_ image: Data) -> Bool {
      let hashes = kindred.fullsizeImageURLs.compactMap { try? Data(contentsOf: $0).hashValue }
      return hashes.contains(image.hashValue)
    }
    
  }
}
