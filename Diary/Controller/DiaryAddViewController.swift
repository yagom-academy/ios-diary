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
    bodyTextView.becomeFirstResponder()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.saveDiary()
  }

  private func saveDiary() {
    var text = bodyTextView.text.components(separatedBy: "\n")
    let title = text.first
    text.removeFirst()
    let body = text.joined(separator: "\n")

    if let title = title, !title.isEmpty {
      DiaryStorageManager.shared.create(
        diary: Diary(title: title, body: body, createdAt: 0)
      )
    }
  }
}
