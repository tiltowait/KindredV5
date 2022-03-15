//
//  CharacterExporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/8/21.
//

import SwiftUI
import PDFKit
import UniformTypeIdentifiers

final class CharacterExporter: Identifiable {
  
  var id = UUID()
  let fileURL: URL
  var exportWarnings: [String: [String]]?
  
  init?(character: Kindred) {
    let tempURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    let destination = tempURL.appendingPathComponent("\(character.name).pdf")
    fileURL = destination
    
    NotificationCenter.default.addObserver(
      self, selector: #selector(exportWarning),
      name: .characterExportWarning,
      object: nil
    )
    
    let pdf = CharacterPDF(character: character).pdf.flattened(withDPI: Global.pdfDPI)
    guard let data = pdf.dataRepresentation() else { return nil }
    
    do {
      try data.write(to: destination)
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }
  
  deinit {
    try? FileManager.default.removeItem(at: fileURL)
  }
  
  @objc func exportWarning(_ notification: Notification) {
    if let errors = notification.userInfo as? [String: [String]] {
      exportWarnings = errors
    }
  }
  
}

extension Notification.Name {
  
  static let characterExportWarning = Notification.Name("exportWarning")
  
}
