//
//  PDFShare.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/12/21.
//

import SwiftUI
import PDFKit

extension Data: Identifiable {
  public var id: Int { hashValue }
}

struct PDFShare: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  let name: String
  let document: PDFDocument
  
  @State private var exportData: Data?
  
  var body: some View {
    NavigationView {
      PDFViewer(document: document)
        .toolbar {
          ToolbarItem(placement: .primaryAction) {
            Button(action: generatePDFData) {
              Label("Share PDF", systemImage: "square.and.arrow.up")
                .labelStyle(.iconOnly)
            }
          }
          ToolbarItem(placement: .cancellationAction) {
            Button("Close", action: dismiss)
          }
        }
        .navigationBarTitle("Export", displayMode: .inline)
    }
    .sheet(item: $exportData) { data in
      ActivityViewController(activityItems: [data], excludedActivityTypes: [.copyToPasteboard])
    }
  }
  
  func generatePDFData() {
    exportData = document.dataRepresentation()
  }
  
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
  
}

struct PDFShare_Previews: PreviewProvider {
  
  static let document = PDFDocument(url: Bundle.main.url(forResource: "Blank Character Sheet", withExtension: "pdf")!)!
  
  static var previews: some View {
    PDFShare(name: "Billy", document: document)
  }
}
