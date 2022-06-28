//
//  DiaryAddViewController.swift
//  Diary
//
//  Created by Minseong, Lingo
//

import UIKit

final class DiaryAddViewController: DiaryBaseViewController {
  private let storageManger: DiaryStorageManager

  init(storageManger: DiaryStorageManager) {
    self.storageManger = storageManger
    super.init(nibName: nil, bundle: nil)
    self.observeDidEnterBackgroundNotification()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.bodyTextView.becomeFirstResponder()
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
      self.storageManger.create(
        diary: Diary(title: title, body: body, createdAt: Date().timeIntervalSince1970)
      )
    }
  }
}
