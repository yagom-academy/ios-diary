//
//  Diary - DiaryViewController.swift
//  Created by Minseong, Lingo
//

import UIKit

final class DiaryViewController: UIViewController {
  private let diaryTableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "일기장"
    self.configureTableView()
  }

  private func configureTableView() {
    self.diaryTableView.dataSource = self
    self.diaryTableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: "DiaryTableViewCell")

    self.view.addSubview(diaryTableView)
    self.diaryTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      diaryTableView.topAnchor.constraint(equalTo: view.topAnchor),
      diaryTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      diaryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      diaryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}

// MARK: - DataSource

extension DiaryViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return 10
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "DiaryTableViewCell",
      for: indexPath) as? DiaryTableViewCell
    else { return UITableViewCell() }

    return cell
  }
}
