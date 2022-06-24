//
//  DiaryDetailViewController.swift
//  Created by Minseong, Lingo
//

import UIKit

final class DiaryDetailViewController: DiaryBaseViewController {
  private let diary: DiaryEntity

  init(diary: DiaryEntity) {
    self.diary = diary
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initializeNavigationBar()
    self.initializeItem()
    self.observePersistentNotification()
    self.bodyTextView.delegate = self
  }

  private func initializeNavigationBar() {
    self.title = Formatter.changeToString(from: self.diary.createdAt)
  }

  private func initializeItem() {
    guard let title = self.diary.title, let body = self.diary.body else { return }

    self.bodyTextView.text = title + "\n\n" + body
  }
}

extension DiaryDetailViewController: UITextViewDelegate {
  func textViewDidEndEditing(_ textView: UITextView) {
    NotificationCenter.default.post(name: DiaryStorageManager.saveNotification, object: nil)
  }

  private func observePersistentNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.updateDiary),
      name: DiaryStorageManager.saveNotification,
      object: nil
    )
  }

  @objc private func updateDiary() {
    var text = self.bodyTextView.text.components(separatedBy: "\n")
    let title = text.first
    text.removeFirst()
    let body = text.joined(separator: "\n")

    self.diary.title = title
    self.diary.body = body

    DiaryStorageManager.shared.saveContext()
    NotificationCenter.default.post(name: DiaryStorageManager.fetchNotification, object: nil)
  }
}
