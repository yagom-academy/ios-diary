//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Diary.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Diary.ID>
    private var persistentContainerManager = PersistentContainerManager()
    private let locationManager = LocationManager()
    private var dataSource: DataSource?
    private var diaries: [Diary] = []

    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionViewLayout()
        configureNavigationItem()
        configureDataSource()
        diaries = persistentContainerManager.fetchDiaries()
        updateSnapshot()
    }

    private func configureCollectionViewLayout() {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = true
        config.trailingSwipeActionsConfigurationProvider = makeSwipeAction
        let viewLayout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = viewLayout
    }

    private func makeSwipeAction(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath,
              let id = dataSource?.itemIdentifier(for: indexPath),
              let diary = diary(diaryID: id) else { return nil }
        let shareActionTitle = NSLocalizedString("Share...", comment: "")
        let shareAction = UIContextualAction(style: .normal, title: shareActionTitle) { [weak self] _, _, _ in
            self?.showActivityView(diary)
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "")
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: deleteActionTitle) { [weak self] _, _, _ in
            self?.persistentContainerManager.deleteDiary(diary)
            self?.delete(diary: diary)
            self?.updateSnapshot()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }

    private func showActivityView(_ diary: Diary) {
        let activityItems = [diary.title, diary.createdAt.currentLocalizedText(), diary.body]
        let activityViewController = UIActivityViewController(activityItems: activityItems,
                                                              applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
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

    private func update(diary: Diary) {
        guard let index = diaries.firstIndex(where: { $0.id == diary.id }) else { return }
        diaries[index] = diary
    }

    private func delete(diary: Diary) {
        guard let index = diaries.firstIndex(where: { $0.id == diary.id }) else { return }
        diaries.remove(at: index)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let diaryID = dataSource?.itemIdentifier(for: indexPath),
              let diary = diary(diaryID: diaryID) else { return }
        let diaryDetailViewController = DiaryDetailViewController(diary: diary) { [weak self] diary, action in
            switch action {
            case .update:
                self?.update(diary: diary)
                self?.updateSnapshot([diary.id])
            case .delete:
                self?.delete(diary: diary)
                self?.updateSnapshot()
            }
        }
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
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
            let hasIconID = diary.iconID != nil
            if hasIconID {
                if let iconImage = diary.iconImage {
                    contentConfiguration.iconImage = iconImage
                } else {
                    self?.loadIconImage(for: diary.id)
                }
            }
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [
                UICellAccessory.disclosureIndicator()
            ]
        }

        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }

    private func updateSnapshot(_ reloadItemIds: [Diary.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(diaries.map { $0.id }, toSection: 0)
        snapshot.reloadItems(reloadItemIds)
        dataSource?.apply(snapshot)
    }

    private func loadIconImage(for diaryID: Diary.ID) {
        guard var diary = diary(diaryID: diaryID),
              let iconID = diary.iconID else { return }
        WeatherIconLoader().load(iconID: iconID) { [weak self] image, error in
            if let error = error {
                print(error)
                return
            }
            guard let image = image else { return }
            diary.iconImage = image
            DispatchQueue.main.async {
                self?.update(diary: diary)
                self?.updateSnapshot([diary.id])
            }
        }
    }
}

// MARK: - objc
extension DiaryListViewController {
    @objc private func touchUpAddButton(_ sender: UIBarButtonItem) {
        let newDiary = Diary(title: "", body: "", createdAt: Date().timeIntervalSince1970)
        persistentContainerManager.insertDiary(newDiary)
        diaries.append(newDiary)
        let diaryDetailViewController = DiaryDetailViewController(diary: newDiary) { [weak self] diary, action in
            switch action {
            case .update:
                self?.update(diary: diary)
                self?.updateSnapshot([diary.id])
            case .delete:
                self?.delete(diary: diary)
                self?.updateSnapshot()
            }
        }
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}
