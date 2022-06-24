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
    self.observeDiaryDidUpdateNotifications()
  }

  private func initializeNavigationBar() {
    self.title = Formatter.changeToString(from: self.diary.createdAt)
    let addButton = UIBarButtonItem(
      image: UIImage(systemName: "ellipsis"),
      style: .plain,
      target: self,
      action: #selector(self.presentActionSheet)
    )
    self.navigationItem.setRightBarButton(addButton, animated: false)
  }

  @objc private func presentActionSheet() {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let sharedAction = UIAlertAction(title: "Share...", style: .default, handler: nil)
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    actionSheet.addAction(sharedAction)
    actionSheet.addAction(deleteAction)
    actionSheet.addAction(cancelAction)

    self.present(actionSheet, animated: true, completion: nil)
  }

  private func initializeItem() {
    guard let title = self.diary.title, let body = self.diary.body else { return }

    self.bodyTextView.text = title + "\n" + body
  }

  private func observeDiaryDidUpdateNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.updateDiary),
      name: UITextView.textDidEndEditingNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.updateDiary),
      name: UIApplication.didEnterBackgroundNotification,
      object: nil)
  }

  @objc private func updateDiary() {
    var text = self.bodyTextView.text.components(separatedBy: "\n")
    let title = text.first
    text.removeFirst()
    let body = text.joined(separator: "\n")

    self.diary.title = title
    self.diary.body = body

    DiaryStorageManager.shared.update()
  }
}
