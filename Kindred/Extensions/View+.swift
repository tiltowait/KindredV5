//
//  View+.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/8/21.
//

import SwiftUI

extension View {
  
  func phoneOnlyStackNavigationView() -> some View {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
    } else {
      return AnyView(self)
    }
  }
  
  /// Force the view to automatically scale its contents to fit the container.
  func autoscaling() -> some View {
    self
      .minimumScaleFactor(0.01)
      .lineLimit(1)
  }
  
}
