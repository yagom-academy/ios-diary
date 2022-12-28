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
        let diaryViewController = DiaryViewController(diary: newDiary)

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

            cell.titleLabel.text = diary.title
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
        let items = CoreDataManager.shared.read()

        snapshot.appendSections([0])
        snapshot.appendItems(items.reversed())

        dataSource?.apply(snapshot)
        diaryList = items.reversed()
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDiary = diaryList[indexPath.row]
        let diaryViewController = DiaryViewController(diary: selectedDiary)

        navigationController?.pushViewController(diaryViewController, animated: true)
        diaryListTableView.deselectRow(at: indexPath, animated: true)
    }
}
