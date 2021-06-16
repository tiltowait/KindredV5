//
//  TextFieldAlert.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/16/21.
//
//  Obtained from https://stackoverflow.com/a/66898103/8341074 on 6/16/21.
//  Modified by Jared Lindsay. Implemented placeholder text instead of default text
//  and made the action argument nil if the string is empty.

import Foundation
import Combine
import SwiftUI

class TextFieldAlertViewController: UIViewController {
  
  /// Presents a UIAlertController (alert style) with a UITextField and a `Done` button
  /// - Parameters:
  ///   - title: to be used as title of the UIAlertController
  ///   - message: to be used as optional message of the UIAlertController
  ///   - text: binding for the text typed into the UITextField
  ///   - isPresented: binding to be set to false when the alert is dismissed (`Done` button tapped)
  init(isPresented: Binding<Bool>, alert: TextFieldAlert) {
    self._isPresented = isPresented
    self.alert = alert
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  @Binding
  private var isPresented: Bool
  private var alert: TextFieldAlert
  
  // MARK: - Private Properties
  private var subscription: AnyCancellable?
  
  // MARK: - Lifecycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presentAlertController()
  }
  
  private func presentAlertController() {
    guard subscription == nil else { return } // present only once
    
    let vc = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
    // add a textField and create a subscription to update the `text` binding
    vc.addTextField {
      // TODO: 需要补充这些参数
      // $0.keyboardType = alert.keyboardType
      // $0.text = alert.defaultValue ?? ""
      $0.placeholder = self.alert.placeholder
    }
    if let cancel = alert.cancel {
      vc.addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
        self.isPresented = false
      })
    }
    let textField = vc.textFields?.first
    vc.addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
      self.isPresented = false
      let isEmpty = textField?.text?.isEmpty ?? true
      self.alert.action(isEmpty ? nil : textField?.text)
    })
    present(vc, animated: true, completion: nil)
  }
}

struct TextFieldAlert {
  
  let title: String
  let message: String?
  var placeholder: String = ""
  public var accept: String = "OK" // The left-most button label
  public var cancel: String? = "Cancel" // The optional cancel (right-most) button label
  public var action: (String?) -> Void // Triggers when either of the two buttons closes the dialog
  
}

struct AlertWrapper:  UIViewControllerRepresentable {
  
  @Binding var isPresented: Bool
  let alert: TextFieldAlert
  
  typealias UIViewControllerType = TextFieldAlertViewController
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWrapper>) -> UIViewControllerType {
    TextFieldAlertViewController(isPresented: $isPresented, alert: alert)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<AlertWrapper>) {
    // no update needed
  }
}

struct TextFieldWrapper<PresentingView: View>: View {
  
  @Binding var isPresented: Bool
  let presentingView: PresentingView
  let content: TextFieldAlert
  
  
  var body: some View {
    ZStack {
      if (isPresented) {
        AlertWrapper(isPresented: $isPresented, alert: content)
      }
      presentingView
    }
  }
}

extension View {
  
  func alert(isPresented: Binding<Bool>, _ content: TextFieldAlert) -> some View {
    TextFieldWrapper(isPresented: isPresented, presentingView: self, content: content)
  }
  
}
