//
//  KindredImage+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

extension KindredImage: Comparable {
  
  var imageURL: URL {
    get { URL.documents.appendingPathComponent(zImage!) }
    set { zImage = newValue.lastPathComponent }
  }
  
  var thumbnailURL: URL {
    get { URL.documents.appendingPathComponent(zThumb!) }
    set { zThumb = newValue.lastPathComponent }
  }

  public static func < (lhs: KindredImage, rhs: KindredImage) -> Bool {
    return lhs.creationDate! < rhs.creationDate!
  }
  
}
