//
//  Diary - DiaryViewController.swift
//  Created by Minseong, Lingo
//

import UIKit

final class DiaryViewController: UIViewController {
  private let diaryTableView = UITableView()
  private var diaries = [Diary]()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "일기장"
    self.configureTableView()
    self.configureNavigationBar()
    self.diaries = Diary.decodedData
  }

  private func configureTableView() {
    self.diaryTableView.dataSource = self
    self.diaryTableView.register(
      DiaryTableViewCell.self,
      forCellReuseIdentifier: "DiaryTableViewCell"
    )

    self.view.backgroundColor = .systemBackground
    self.view.addSubview(diaryTableView)
    self.diaryTableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      diaryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      diaryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      diaryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

  private func configureNavigationBar() {
    let addButton = UIBarButtonItem(
      image: UIImage(systemName: "plus"),
      style: .plain,
      target: self,
      action: nil
    )
    self.navigationItem.setRightBarButton(addButton, animated: false)
  }
}

// MARK: - DataSource

extension DiaryViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return diaries.count
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "DiaryTableViewCell",
      for: indexPath) as? DiaryTableViewCell
    else { return UITableViewCell() }

    cell.setUp(diary: diaries[indexPath.row])

    return cell
  }
}
