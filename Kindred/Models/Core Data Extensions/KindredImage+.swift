//
//  KindredImage+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import Foundation

extension KindredImage: Comparable {
  
  public static func < (lhs: KindredImage, rhs: KindredImage) -> Bool {
    return lhs.creationDate! < rhs.creationDate!
  }
  
}
