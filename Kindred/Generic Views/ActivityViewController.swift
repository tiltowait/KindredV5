//
//  ActivityViewController.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/12/21.
//

import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
  
  typealias UIViewType = UIActivityViewController
  
  var activityItems: [Any]
  var excludedActivityTypes: [UIActivity.ActivityType]? = nil
  
  func makeUIViewController(context: Context) -> UIActivityViewController {
    let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    controller.excludedActivityTypes = excludedActivityTypes
    
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    // Nothing here
  }
  
}
