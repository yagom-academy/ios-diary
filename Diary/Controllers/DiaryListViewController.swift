//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Diary.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Diary.ID>
    private let persistentContainerManager = PersistentContainerManager(PersistentContainer.shared)
    private var dataSource: DataSource?
    private var diaries: [Diary] = []

    init() {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = true
        let viewLayout = UICollectionViewCompositionalLayout.list(using: config)

        super.init(collectionViewLayout: viewLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItem()
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        diaries = persistentContainerManager.fetchDiaries()
        updateSnapshot()
    }

    private func configureNavigationItem() {
        navigationItem.title = NSLocalizedString("Diary", comment: "diary title")
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                        style: .plain, target: self,
                                        action: #selector(touchUpAddButton))
        navigationItem.rightBarButtonItem = addButton
    }

    private func diary(diaryID: Diary.ID) -> Diary? {
        guard let diary = diaries.first(where: { diary in
            diary.id == diaryID
        }) else { return nil }
        return diary
    }
}

// MARK: - DataSource
extension DiaryListViewController {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Diary.ID> { [weak self] cell, _, itemIdentifier in
            var contentConfiguration = DiaryListContentView.Configuration()
            guard let diary = self?.diary(diaryID: itemIdentifier) else {
                cell.contentConfiguration = contentConfiguration
                return
            }

            contentConfiguration.title = diary.title
            contentConfiguration.body = diary.body
            contentConfiguration.createdAt = diary.createdAt
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [
                UICellAccessory.disclosureIndicator()
            ]
        }

        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }

    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(diaries.map { $0.id }, toSection: 0)
        dataSource?.apply(snapshot)
    }
}

// MARK: - objc
extension DiaryListViewController {
    @objc private func touchUpAddButton(_ sender: UIBarButtonItem) {
        let diaryRegistrationViewController = DiaryRegistrationViewController()
        navigationController?.pushViewController(diaryRegistrationViewController, animated: true)
    }
}
