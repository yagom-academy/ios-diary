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

  private let storageManger = DiaryStorageManager()
  private var diaries = [Diary]() {
    didSet {
      DispatchQueue.main.async {
        self.diaryTableView.reloadData()
      }
    }
  }

  init() {
    super.init(nibName: nil, bundle: nil)
    self.initializeNavigationBar()
    self.observeDiaryWasSavedNotification()
    self.observeDiaryWasDeletedNotification()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.initializeUI()
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
    let addViewController = DiaryAddViewController(storageManger: storageManger)
    self.navigationController?.pushViewController(addViewController, animated: true)
  }

  @objc private func fetchDiaries() {
    self.diaries = self.storageManger.fetchAllDiaries()
  }

  private func observeDiaryWasSavedNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.fetchDiaries),
      name: DiaryStorageNotification.diaryWasSaved,
      object: nil
    )
  }

  private func observeDiaryWasDeletedNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.fetchDiaries),
      name: DiaryStorageNotification.diaryWasDeleted,
      object: nil
    )
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
    let detailViewController = DiaryDetailViewController(
      storageManager: storageManger,
      diary: self.diaries[indexPath.row]
    )
    self.navigationController?.pushViewController(detailViewController, animated: true)
  }

  func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    let diary = self.diaries[indexPath.row]

    let share = UIContextualAction(style: .normal, title: "공유") { _, _, _ in
      self.presentShareActivityController(diary: diary)
    }
    let delete = UIContextualAction(style: .destructive, title: "삭제") { _, _, _ in
      self.presentDeleteAlert(diary: diary)
    }

    let configuration = UISwipeActionsConfiguration(actions: [delete, share])
    return configuration
  }

  private func presentShareActivityController(diary: Diary) {
    guard let title = diary.title else { return }
    let activityController = UIActivityViewController(activityItems: [title], applicationActivities: nil)
    self.present(activityController, animated: true)
  }

  private func presentDeleteAlert(diary: Diary) {
    let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
      self.deleteDiary(diary: diary)
    }

    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    self.present(alert, animated: true)
  }

  private func deleteDiary(diary: Diary) {
    guard let uuid = diary.uuid else { return }

    self.storageManger.delete(uuid: uuid)
  }
}
