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
    container.addSubview(self.bodyTextView)
    container.translatesAutoresizingMaskIntoConstraints = false
    self.bodyTextView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      container.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor,
        constant: 8.0
      ),
      container.bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
      ),
      container.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
        constant: 8.0
      ),
      container.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
        constant: -8.0
      ),

      self.bodyTextView.topAnchor.constraint(equalTo: container.contentLayoutGuide.topAnchor),
      self.bodyTextView.bottomAnchor.constraint(equalTo: container.contentLayoutGuide.bottomAnchor),
      self.bodyTextView.leadingAnchor.constraint(equalTo: container.contentLayoutGuide.leadingAnchor),
      self.bodyTextView.trailingAnchor.constraint(equalTo: container.contentLayoutGuide.trailingAnchor),
      self.bodyTextView.widthAnchor.constraint(equalTo: container.widthAnchor),
      self.bodyTextView.heightAnchor.constraint(equalTo: container.heightAnchor, constant: 1)
    ])
  }

  private func observeKeyboardNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  @objc private func keyboardWillShow(_ notification: Notification) {
    if !self.isKeyboardVisible {
      guard let userInfo = notification.userInfo else { return }
      guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

      let contentInset = UIEdgeInsets(bottom: keyboardFrame.height)
      self.bodyTextView.contentInset = contentInset
      self.bodyTextView.verticalScrollIndicatorInsets = contentInset
      self.isKeyboardVisible = true
    }
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    if self.isKeyboardVisible {
      let contentInset = UIEdgeInsets.zero
      self.bodyTextView.contentInset = contentInset
      self.bodyTextView.scrollIndicatorInsets = contentInset
      self.isKeyboardVisible = false
    }
  }
}
