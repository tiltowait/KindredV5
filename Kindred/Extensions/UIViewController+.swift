//
//  UIViewController+.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/18/21.
//
//  Inspired by https://github.com/shamiul110107/Modal-Presentation-with-transparent-background-and-crossDissolve-style-in-swiftUI
//  and https://gist.github.com/fullc0de/3d68b6b871f20630b981c7b4d51c8373. Taken 6/18/21.

import SwiftUI

// MARK: - Environment Variable Stuff

struct ViewControllerHolder {
  weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
  static var defaultValue: ViewControllerHolder {
    ViewControllerHolder(value: UIViewController.root)
  }
}

extension EnvironmentValues {
  var viewController: UIViewController? {
    get { self[ViewControllerKey.self].value }
    set { self[ViewControllerKey.self].value = newValue }
  }
}

// MARK: - UIViewController SwiftUI View Presentation

extension UIViewController {
  
  /// The application's root view controller.
  static var root: UIViewController? {
    UIApplication.shared.windows.first?.rootViewController
  }
  
  /// The topmost view controller.
  static var topMost: UIViewController? {
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    
    if var topController = keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      return topController
    }
    return nil
  }
  
  /// Modally present a view.
  /// - Parameters:
  ///   - style: The modal presentation style to use.
  ///   - transitionStyle: The transition style to use.
  ///   - builder: The view's contents.
  func present<Content: View>(
    style: UIModalPresentationStyle = .overFullScreen,
    transitionStyle: UIModalTransitionStyle = .crossDissolve,
    @ViewBuilder contents: () -> Content
  ) {
    let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
    
    toPresent.modalPresentationStyle = style
    toPresent.modalTransitionStyle = transitionStyle
    toPresent.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5) // Dim the screen
    
    toPresent.rootView = AnyView(
      contents()
        .environment(\.viewController, toPresent)
    )
    
    self.present(toPresent, animated: true, completion: nil)
  }
  
}
