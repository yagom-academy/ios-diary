//
//  DiaryDetailViewController.swift
//  Created by Minseong, Lingo
//

import UIKit

final class DiaryDetailViewController: DiaryBaseViewController {
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
    self.initializeNavigationBar()
    self.initializeItem()
  }

  private func initializeNavigationBar() {
    self.title = Formatter.changeToString(from: self.diary.createdAt)
  }

  private func initializeItem() {
    self.bodyTextView.text = self.diary.title + "\n\n" + self.diary.body
  }
}
