//
//  UIImage+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import UIKit

extension UIImage {
  
  /// Proportionally resize the image constrained by a specified height.
  /// - Parameter height: The desired height of the resized image.
  /// - Returns: The resized image.
  func resize(height: CGFloat) -> UIImage {
    // Calculate the new size
    let targetHeight: CGFloat = 100
    let ratio = targetHeight / self.size.height
    let targetWidth = self.size.width * ratio
    
    let newSize = CGSize(width: targetWidth, height: targetHeight)
    let rect = CGRect(origin: .zero, size: newSize)
    
    // Draw the resized UIImage
    let renderer = UIGraphicsImageRenderer(size: newSize)
    let scaledImage = renderer.image { _ in
      self.draw(in: rect)
    }
    
    return scaledImage
  }
  
}
