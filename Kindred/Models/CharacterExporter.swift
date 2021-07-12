//
//  CharacterExporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/8/21.
//

import SwiftUI
import PDFKit
import UniformTypeIdentifiers

class CharacterExporter: Identifiable {
  
  var id = UUID()
  
  let fileURL: URL
  
  init?(character: Kindred) {
    let pdf = CharacterPDF(character: character).pdf.flattened(withDPI: Global.pdfDPI)
    guard let data = pdf.dataRepresentation() else { return nil }
    
    let tempURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    let destination = tempURL.appendingPathComponent("\(character.name).pdf")
    
    do {
      try data.write(to: destination)
      fileURL = destination
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
  
  deinit {
    try? FileManager.default.removeItem(at: fileURL)
  }
  
}
