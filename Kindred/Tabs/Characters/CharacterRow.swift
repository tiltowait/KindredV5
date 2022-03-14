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
    if let thumbnail = kindred.icon,
       let uiImage = UIImage(data: thumbnail) {
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
  
  var body: some View {
    ReferenceRow(
      kindred.name,
      subtitle: subtitle,
      icon: image,
      rounded: true
    )
  }
  
}

#if DEBUG
struct KindredRow_Previews: PreviewProvider {
  static var previews: some View {
    CharacterRow(kindred: Kindred.example)
      .previewLayout(.sizeThatFits)
  }
}
#endif
