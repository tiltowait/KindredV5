//
//  CharacterExporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/8/21.
//

import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct CharacterExporter: Identifiable {
  
  var id = UUID()
  
  let character: Kindred
  let pdf: PDFDocument
  
  init(character: Kindred) {
    self.character = character
    self.pdf = CharacterPDF(character: character).pdf
  }
  
  func flattenedPDF() -> PDFDocument {
    pdf.flattened(withDPI: Global.pdfDPI)
  }
  
}
