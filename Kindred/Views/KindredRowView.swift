//
//  KindredRowView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/14/21.
//

import SwiftUI

struct KindredRowView: View {
  
  let image: Image?
  let kindred: Kindred
  
  init(kindred: Kindred) {
    self.kindred = kindred
    
    // Get the first image for display
    if let imageData = kindred.thumbnailImageData.first,
       let uiImage = UIImage(data: imageData) {
      self.image = Image(uiImage: uiImage)
    } else {
      self.image = nil
    }
  }
  
  var generation: String {
    let generation = String(kindred.generation)
    if generation.last == "3" {
      return "\(generation)rd"
    } else {
      return "\(generation)th"
    }
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
        Text("\(generation)-generation Hecata")
          .font(.caption)
          .foregroundColor(.secondary)
      }
    }
  }
  
}
//
//struct KindredRowView_Previews: PreviewProvider {
//  static var previews: some View {
//    KindredRowView()
//  }
//}
