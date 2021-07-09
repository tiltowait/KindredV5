//
//  PDF+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/9/21.
//
//  Taken from https://gist.github.com/chrischute/881b039cb9db36994c8ec3a2fc0ff707 on 7/9/21.

import PDFKit
import UIKit

extension PDFPage {
  func image(withDPI dpi: CGFloat) -> UIImage {
    let pageRect = bounds(for: .mediaBox)
    let dpiRatio = dpi / 72  // Default DPI is 72
    let scaleTransform = CGAffineTransform(scaleX: dpiRatio, y: dpiRatio)
    let imageSize = pageRect.size.applying(scaleTransform)
    let renderer = UIGraphicsImageRenderer(size: imageSize)
    return renderer.image { ctx in
      ctx.cgContext.saveGState()
      ctx.cgContext.translateBy(x: 0, y: imageSize.height)
      ctx.cgContext.scaleBy(x: dpiRatio, y: -dpiRatio)
      draw(with: .mediaBox, to: ctx.cgContext)
      ctx.cgContext.restoreGState()
    }
  }
}

extension PDFDocument {
  func flattened(withDPI dpi: CGFloat) -> PDFDocument {
    let flattenedDocument = PDFDocument()
    for pageIndex in 0..<pageCount {
      if let oldPage = page(at: pageIndex),
         let flattenedPage = PDFPage(image: oldPage.image(withDPI: dpi)) {
        flattenedDocument.insert(flattenedPage, at: flattenedDocument.pageCount)
      }
    }
    return flattenedDocument
  }
}
