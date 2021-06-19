//
//  CharacterRow.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

struct CharacterRow: View {
  
  let image: Image?
  let kindred: Kindred
  let subtitle: String
  
  init(kindred: Kindred) {
    self.kindred = kindred
    
    // Get the first image for display
    if let imageData = kindred.thumbnailImageData.first,
       let uiImage = UIImage(data: imageData) {
      self.image = Image(uiImage: uiImage)
    } else {
      self.image = nil
    }
    
    let clan = kindred.clan?.name ?? "Unknown"
    if kindred.generation != -1 {
      subtitle = "\(kindred.generation)th-generation \(clan)"
    } else {
      subtitle = "\(clan)"
    }
  }
  
  var generation: String {
    "\(kindred.generation)th"
  }
  
  var body: some View {
    HStack {
      if let image = image {
        image
          .resizable()
          .scaledToFit()
          .cornerRadius(10)
          .frame(height: 50)
      }
      VStack(alignment: .leading) {
        Text(kindred.name)
          .font(.headline)
        Text(subtitle)
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
  }
  
}

struct KindredRow_Previews: PreviewProvider {
  static var previews: some View {
    CharacterRow(kindred: Kindred.example)
      .previewLayout(.sizeThatFits)
  }
}
