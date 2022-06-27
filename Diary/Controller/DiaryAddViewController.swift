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
    self.saveDiary()
  }

  private func observeDidEnterBackgroundNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.saveDiary),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil
    )
  }

  @objc private func saveDiary() {
    var text = self.bodyTextView.text.components(separatedBy: "\n")
    let title = text.first
    text.removeFirst()
    let body = text.joined(separator: "\n")

    if let title = title, !title.isEmpty {
      DiaryStorageManager.shared.create(
        diary: Diary(title: title, body: body, createdAt: Date().timeIntervalSince1970)
      )
      NotificationCenter.default.post(name: DiaryStorageNotification.diaryWasSaved, object: nil)
    }
  }
}
