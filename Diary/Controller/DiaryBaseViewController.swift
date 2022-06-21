//
//  DiaryBaseViewController.swift
//  Diary
//
//  Created by Minseong, Lingo
//

import UIKit

class DiaryBaseViewController: UIViewController {
  let bodyTextView = UITextView().then {
    $0.font = .preferredFont(forTextStyle: .body)
    $0.adjustsFontForContentSizeCategory = true
  }

  private var isKeyboardVisible = false

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initializeUI()
    self.observeKeyboardNotifications()
  }

  private func initializeUI() {
    self.view.backgroundColor = .systemBackground

    let container = UIScrollView()
    self.view.addSubview(container)
    container.addSubview(bodyTextView)
    container.translatesAutoresizingMaskIntoConstraints = false
    bodyTextView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      container.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: 8.0
      ),
      container.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor
      ),
      container.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: 8.0
      ),
      container.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -8.0
      ),

      bodyTextView.topAnchor.constraint(equalTo: container.contentLayoutGuide.topAnchor),
      bodyTextView.bottomAnchor.constraint(equalTo: container.contentLayoutGuide.bottomAnchor),
      bodyTextView.leadingAnchor.constraint(equalTo: container.contentLayoutGuide.leadingAnchor),
      bodyTextView.trailingAnchor.constraint(equalTo: container.contentLayoutGuide.trailingAnchor),
      bodyTextView.widthAnchor.constraint(equalTo: container.widthAnchor),
      bodyTextView.heightAnchor.constraint(equalTo: container.heightAnchor, constant: 1)
    ])
  }

  private func observeKeyboardNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  @objc private func keyboardWillShow(_ notification: Notification) {
    if !isKeyboardVisible {
      guard let userInfo = notification.userInfo else { return }
      guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

      let contentInset = UIEdgeInsets(bottom: keyboardFrame.height)
      self.bodyTextView.contentInset = contentInset
      self.bodyTextView.verticalScrollIndicatorInsets = contentInset
      self.isKeyboardVisible = true
    }
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    if isKeyboardVisible {
      let contentInset = UIEdgeInsets.zero
      self.bodyTextView.contentInset = contentInset
      self.bodyTextView.scrollIndicatorInsets = contentInset
      self.isKeyboardVisible = false
    }
  }
}
