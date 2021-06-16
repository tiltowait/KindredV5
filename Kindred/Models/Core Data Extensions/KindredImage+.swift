//
//  KindredImage+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import UIKit

extension KindredImage: Comparable {
  
  public static func < (lhs: KindredImage, rhs: KindredImage) -> Bool {
    return lhs.creationDate! < rhs.creationDate!
  }
  
}

extension KindredImage {
  
  static var examples: [KindredImage] {
    guard let image1 = UIImage(named: "nadea"),
          let image2 = UIImage(named: "nadea-portrait")
    else { return [] }
    
    var images: [KindredImage] = []
    var creationOffset: TimeInterval = -1 // One image's creation date should be before the other
    
    for fullSized in [image1, image2] {
      let ki = KindredImage(context: DataController.preview.container.viewContext)
      let thumbnail = fullSized.resize(height: 100)
      
      ki.image = fullSized.pngData()!
      ki.thumb = thumbnail.pngData()!
      ki.creationDate = Date(timeIntervalSinceNow: creationOffset)
      creationOffset += 1
      
      images.append(ki)
    }
    return images
  }
  
}
