//
//  KindredImage+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

extension KindredImage: Comparable {
  
  var fullsize: Data {
    get { zImage ?? Data() }
    set { zImage = newValue }
  }
  
  var thumbnail: Data {
    get { zThumb ?? Data() }
    set { zThumb = newValue }
  }

  public static func < (lhs: KindredImage, rhs: KindredImage) -> Bool {
    return lhs.creationDate! < rhs.creationDate!
  }
  
}
