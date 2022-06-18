//
//  Diary - DiaryViewController.swift
//  Created by Minseong, Lingo
//

import UIKit

final class DiaryViewController: UIViewController {
  private lazy var diaryTableView = UITableView().then {
    $0.dataSource = self
    $0.delegate = self
    $0.register(
      DiaryTableViewCell.self,
      forCellReuseIdentifier: DiaryTableViewCell.identifier
    )
  }

  private var diaries = [Diary]()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initializeUI()
    self.initializeNavigationBar()
    self.fetchDiaries()
  }

  private func initializeUI() {
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

  private func initializeNavigationBar() {
    self.title = "일기장"
    let addButton = UIBarButtonItem(
      image: UIImage(systemName: "plus"),
      style: .plain,
      target: self,
      action: nil
    )
    self.navigationItem.setRightBarButton(addButton, animated: false)
  }

  private func fetchDiaries() {
    guard let result = Parser.decode(type: [Diary].self, assetName: "sample") else { return }
    self.diaries = result
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
      withIdentifier: DiaryTableViewCell.identifier,
      for: indexPath) as? DiaryTableViewCell
    else { return UITableViewCell() }

    cell.configureItem(diaries[indexPath.row])

    return cell
  }
}

// MARK: - Delegate

extension DiaryViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
    let detailViewController = DiaryDetailViewController(diary: diaries[indexPath.row])
    self.navigationController?.pushViewController(detailViewController, animated: true)
  }
}
