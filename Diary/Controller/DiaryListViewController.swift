//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    typealias DiaryDataSource = UITableViewDiffableDataSource<Int, Diary>
    typealias DiarySnapShot = NSDiffableDataSourceSnapshot<Int, Diary>

    private lazy var presentNewDiaryViewAction = UIAction { _ in
        let newDiary = Diary(title: "", body: "", createdAt: Date())
        let diaryViewController = DiaryViewController(diary: newDiary, isNewDiary: true)

        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }

    private lazy var addDiaryButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .add,
                                     primaryAction: presentNewDiaryViewAction)

        return button
    }()

    private lazy var diaryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DiaryListCell.self, forCellReuseIdentifier: DiaryListCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self

        return tableView
    }()

    private var dataSource: DiaryDataSource?
    private var diaryList: [Diary] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureHierarchy()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureSnapshot()
    }
}

extension DiaryListViewController {
    private func configureNavigationBar() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = addDiaryButton
    }

    private func configureHierarchy() {
        view.addSubview(diaryListTableView)

        NSLayoutConstraint.activate([
            diaryListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            diaryListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    private func configureDataSource() {
        dataSource = DiaryDataSource(tableView: diaryListTableView, cellProvider: { tableView, indexPath, diary in
            let cell = tableView.dequeueReusableCell(cellType: DiaryListCell.self, for: indexPath)

            cell.titleLabel.text = diary.title.isEmpty ? "제목 없음" : diary.title
            cell.subtitleLabel.attributedText = self.configureSubtitleText(diary.createdAt, diary.body)

            return cell
        })
    }

    private func configureSubtitleText(_ date: Date, _ body: String) -> NSMutableAttributedString {
        let text: String = "\(date.localeFormattedText)  \(body)"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([.font: UIFont.preferredFont(forTextStyle: .callout)],
                                       range: (text as NSString).range(of: "\(date.localeFormattedText)  "))

        return attributedString
    }

    private func configureSnapshot() {
        var snapshot = DiarySnapShot()
        let sortedByLatestItems: [Diary] = CoreDataManager.shared.readDiaryList().reversed()

        snapshot.appendSections([0])
        snapshot.appendItems(sortedByLatestItems)

        dataSource?.apply(snapshot)
        diaryList = sortedByLatestItems
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDiary = diaryList[indexPath.row]
        let diaryViewController = DiaryViewController(diary: selectedDiary)

        navigationController?.pushViewController(diaryViewController, animated: true)
        diaryListTableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: nil) { (_, _, success) in
            self.showActivityViewController(diary: self.diaryList[indexPath.row])
            success(true)
        }
        shareAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: "square.and.arrow.up")

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, success) in
            self.showDeleteActionAlert(diary: self.diaryList[indexPath.row])
            success(true)
        }
        deleteAction.image = UIImage(systemName: "trash")

        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        swipeActionConfiguration.performsFirstActionWithFullSwipe = false

        return swipeActionConfiguration
    }

    private func showDeleteActionAlert(diary: Diary) {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            CoreDataManager.shared.delete(diary: diary)
            self.configureSnapshot()
        }

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true)
    }

    private func showActivityViewController(diary: Diary) {
        let textToShare: String = "\(diary.title)\n\(diary.body)"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)

        self.present(activityViewController, animated: true, completion: nil)
    }
}
