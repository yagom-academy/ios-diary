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
        convertDiaryData()
        configureDiaryListDataSource()
        snapShot()
        setupNavigationBar()
        diaryListView?.diaryList?.delegate = self
    }
    
    private func convertDiaryData() {
        guard let data = NSDataAsset(name: "sample")?.data else {
            return
        }
        
        diary = DecodeManager.decodeDiaryData(data) ?? []
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
        let registerDiaryViewController = RegisterDiaryViewController()
    
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
