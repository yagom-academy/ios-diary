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
  }

  private func initializeNavigationBar() {
    self.title = Formatter.changeToString(from: self.diary.createdAt)
  }

  private func initializeItem() {
    guard let title = diary.title, let body = diary.body else { return }

    self.bodyTextView.text = title + "\n\n" + body
  }
}
