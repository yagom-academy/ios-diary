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

  private var diaries = [DiaryEntity]()

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
      self.diaryTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      self.diaryTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
      self.diaryTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      self.diaryTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
  }

  private func initializeNavigationBar() {
    self.title = "일기장"
    let addButton = UIBarButtonItem(
      image: UIImage(systemName: "plus"),
      style: .plain,
      target: self,
      action: #selector(addDiaryButtonDidTap)
    )
    self.navigationItem.setRightBarButton(addButton, animated: false)
  }

  @objc private func addDiaryButtonDidTap() {
    let addViewController = DiaryAddViewController()
    self.navigationController?.pushViewController(addViewController, animated: true)
  }

  private func fetchDiaries() {
    self.diaries = DiaryStorageManager.shared.fetchAll()
  }
}

// MARK: - DataSource

extension DiaryViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return self.diaries.count
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard self.diaries.indices.contains(indexPath.row) else { return UITableViewCell() }
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: DiaryTableViewCell.identifier,
      for: indexPath) as? DiaryTableViewCell
    else { return UITableViewCell() }

    cell.configureItem(self.diaries[indexPath.row])

    return cell
  }
}

// MARK: - Delegate

extension DiaryViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    guard self.diaries.indices.contains(indexPath.row) else { return }

    tableView.deselectRow(at: indexPath, animated: true)
    let detailViewController = DiaryDetailViewController(diary: self.diaries[indexPath.row])
    self.navigationController?.pushViewController(detailViewController, animated: true)
  }
}
