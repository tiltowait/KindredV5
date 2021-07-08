//
//  CharacterExporter.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/8/21.
//

import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct CharacterExporter: FileDocument {
  enum PDFError: Error {
    case invalidPDFData
  }
  
  static var readableContentTypes = [UTType.pdf]
  
  let character: Kindred
  
  init(configuration: ReadConfiguration) throws {
    print("init(configuration:)")
    character = Kindred()
  }
  
  init(character: Kindred) {
    self.character = character
  }
  
  func generatePDF() -> CharacterPDF {
    CharacterPDF(character: character)
  }
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    let data = generatePDF().dataRepresentation()
    return FileWrapper(regularFileWithContents: data!)
  }
  
}
