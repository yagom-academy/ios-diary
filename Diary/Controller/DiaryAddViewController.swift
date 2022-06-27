//
//  DiaryAddViewController.swift
//  Diary
//
//  Created by Minseong, Lingo
//

import UIKit

final class DiaryAddViewController: DiaryBaseViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.bodyTextView.becomeFirstResponder()
    self.observeDidEnterBackgroundNotification()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.createDiary()
  }

  private func observeDidEnterBackgroundNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.createDiary),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil
    )
  }

  @objc private func createDiary() {
    var text = self.bodyTextView.text.components(separatedBy: "\n")
    let title = text.first
    text.removeFirst()
    let body = text.joined(separator: "\n")

    if let title = title, !title.isEmpty {
      DiaryStorageManager.shared.create(
        diary: Diary(title: title, body: body, createdAt: Date().timeIntervalSince1970)
      )
    }
  }
}
