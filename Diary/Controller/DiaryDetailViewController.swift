//
//  DiaryDetailViewController.swift
//  Created by Minseong, Lingo
//

import UIKit

final class DiaryDetailViewController: DiaryBaseViewController {
  private var diary: Diary
  private let storageManger: DiaryStorageManager

  init(storageManager: DiaryStorageManager, diary: Diary) {
    self.diary = diary
    self.storageManger = storageManager
    super.init(nibName: nil, bundle: nil)
    self.initializeNavigationBar()
    self.observeDiaryDidUpdateNotifications()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initializeItem()
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
    let sharedAction = UIAlertAction(title: "Share...", style: .default) { _ in
      self.presentShareActivityController()
    }
    let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
      self.presentDeleteAlert()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    actionSheet.addAction(sharedAction)
    actionSheet.addAction(deleteAction)
    actionSheet.addAction(cancelAction)

    self.present(actionSheet, animated: true)
  }

  private func presentDeleteAlert() {
    let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
      self.deleteDiary()
    }

    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    self.present(alert, animated: true)
  }

  private func deleteDiary() {
    guard let uuid = self.diary.uuid else { return }

    self.storageManger.delete(uuid: uuid)
    self.navigationController?.popViewController(animated: true)
  }

  private func presentShareActivityController() {
    guard let title = diary.title else { return }
    let activityController = UIActivityViewController(activityItems: [title], applicationActivities: nil)
    self.present(activityController, animated: true)
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
      object: nil
    )
  }

  @objc private func updateDiary() {
    guard let uuid = self.diary.uuid else { return }
    self.storageManger.update(uuid: uuid, text: self.bodyTextView.text)
  }
}
