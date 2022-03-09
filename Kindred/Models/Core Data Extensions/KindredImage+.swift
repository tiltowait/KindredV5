//
//  KindredImage+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

extension KindredImage: Comparable {
  
  // This is a rather gross hack. The simulator makes a new directories
  // document each time it runs, so we calculate the proper directory
  // URL each time we run in order to make the simulator work.
  //
  // If not for this, we could just use the URI field type of Core Data.
  // Perhaps we will in the future.
  var directoryToUse: URL {
    if self.directoryKey == -1 { // Unset
      directoryKey = URL.cloudDocuments == nil ? 0 : 1
    }
    
    if self.directoryKey == 1 {
      return URL.documents
    }
    return URL.localDocuments
  }
  
  var imageURL: URL {
    get { self.directoryToUse.appendingPathComponent(zImage!) }
    set { zImage = newValue.lastPathComponent }
  }
  
  var thumbnailURL: URL {
    get { self.directoryToUse.appendingPathComponent(zThumb!) }
    set { zThumb = newValue.lastPathComponent }
  }

  public static func < (lhs: KindredImage, rhs: KindredImage) -> Bool {
    return lhs.creationDate! < rhs.creationDate!
  }
  
}
