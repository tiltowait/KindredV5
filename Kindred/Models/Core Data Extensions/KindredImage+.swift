//
//  KindredImage+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

extension KindredImage: Comparable {
  
  var imageURL: URL {
    get { URL(string: zImage!)! }
    set { zImage = newValue.absoluteString }
  }
  
  var thumbnailURL: URL {
    get { URL(string: zThumb!)! }
    set { zThumb = newValue.absoluteString }
  }

  public static func < (lhs: KindredImage, rhs: KindredImage) -> Bool {
    return lhs.creationDate! < rhs.creationDate!
  }
  
}
