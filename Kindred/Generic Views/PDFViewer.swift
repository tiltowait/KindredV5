//
//  PDFViewer.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/12/21.
//

import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
  
  typealias UIViewType = PDFView
  
  let document: PDFDocument
  
  func makeUIView(context: Context) -> PDFView {
    PDFView()
  }
  
  func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFViewer>) {
    uiView.document = document
    uiView.scaleFactor = uiView.scaleFactorForSizeToFit
    uiView.autoScales = true
  }
  
}
