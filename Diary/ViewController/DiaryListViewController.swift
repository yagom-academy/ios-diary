//
//  DiaryListViewController.swift
//  Created by 써니쿠키, LJ.
//  Copyright © 써니쿠키, LJ. All rights reserved.
//

import UIKit

final class DiaryListViewController: UIViewController {
    
    private var diaryListView: DiaryListView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, DiaryPage>?
    private var diary: [DiaryPage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryListView = DiaryListView()
        self.view = diaryListView
        setupNavigationBar()
        diaryListView?.diaryList?.delegate = self
        diaryListView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        convertDiaryData()
        configureDiaryListDataSource()
        snapShot()
    }
    
    private func convertDiaryData() {
        diary = CoreDataManager.shared.fetchDiaryPages()
    }
    
    private func configureDiaryListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<DiaryCell, DiaryPage> {
            cell, indexPath, diary in
            cell.configureCell(title: self.diary[indexPath.item].title,
                               date: self.diary[indexPath.item].createdDate,
                               preview: self.diary[indexPath.item].body)
        }
        
        guard let diaryListView = diaryListView,
            let diaryListView = diaryListView.diaryList else {
            return
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: diaryListView,
                                                        cellProvider: {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                         for: indexPath,
                                                         item: itemIdentifier)
        })
    }
    
    private func snapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryPage>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diary)
        dataSource?.apply(snapshot)
    }
}

extension DiaryListViewController {
    
    private enum Section {
        case main
    }
}

extension DiaryListViewController {
    
    private func setupNavigationBar() {
        self.navigationItem.title = "일기장"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let addBarButtonItem = UIBarButtonItem(title: "+",
                                               style: .plain,
                                               target: self,
                                               action: #selector(registerDiary))
        
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    @objc private func registerDiary() {
        let registerDiaryViewController = RegisterDiaryViewController(
            diary: DiaryPage(title: "", body: "", createdAt: Date()))
    
        self.navigationController?.pushViewController(registerDiaryViewController, animated: true)
    }
}

extension DiaryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DiaryDetailViewController(diary: diary[indexPath.item])
        collectionView.deselectItem(at: indexPath, animated: false)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension DiaryListViewController: DiaryListViewDelegate {
    func configureSwipeActions(indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let deleteAction = UIContextualAction(style: .destructive,
                                        title: "delete") {
            _, _, handler in

            CoreDataManager.shared.delete(self.diary[indexPath.item])
            guard let dataSource = self.dataSource else { return }
            guard let id = dataSource.itemIdentifier(for: indexPath) else { return }
            var currentData = dataSource.snapshot()
            currentData.deleteItems([id])
            dataSource.apply(currentData)
            handler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal,
                                             title: "share") {
            _, _, handler in
        
            let title = self.diary[indexPath.item].title
            let body = self.diary[indexPath.item].body
            let activityViewController = CustomActivityViewController(activityItems: [title, body])
        
            self.present(activityViewController, animated: true)
            handler(true)
        }
        shareAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}
