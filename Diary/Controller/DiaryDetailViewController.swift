//
//  DiaryDetailViewController.swift
//  Created by Minseong, Lingo
//

import UIKit

final class DiaryDetailViewController: UIViewController {
  private let titleLabel = UILabel()
  private let bodyTextView = UITextView()
  private let diary: Diary

  init(diary: Diary) {
    self.diary = diary
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configure()
    self.setNotificationCenter()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.removeNotificationCenter()
  }

  private func configure() {
    self.title = diary.createdAtString
    self.view.backgroundColor = .systemBackground

    self.titleLabel.font = .preferredFont(forTextStyle: .headline)
    self.titleLabel.adjustsFontForContentSizeCategory = true
    self.titleLabel.text = diary.title

    self.bodyTextView.font = .preferredFont(forTextStyle: .body)
    self.bodyTextView.adjustsFontForContentSizeCategory = true
    self.bodyTextView.text = diary.body

    let container = UIStackView(arrangedSubviews: [titleLabel, bodyTextView])
    container.axis = .vertical
    container.spacing = 20.0

    self.view.addSubview(container)
    container.translatesAutoresizingMaskIntoConstraints = false
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
      )
    ])
  }

  private func setNotificationCenter() {
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

  private func removeNotificationCenter() {
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )

    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  @objc private func keyboardWillShow(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    else { return }
    let contentInset = UIEdgeInsets(
      top: .zero,
      left: .zero,
      bottom: keyboardFrame.height,
      right: .zero
    )
    self.bodyTextView.contentInset = contentInset
    self.bodyTextView.verticalScrollIndicatorInsets = contentInset
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    let contentInset = UIEdgeInsets.zero
    self.bodyTextView.contentInset = contentInset
    self.bodyTextView.scrollIndicatorInsets = contentInset
  }
}
