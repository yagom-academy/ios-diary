//
//  Diary - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var diaryListView: DiaryListView?
    var dataSource: UICollectionViewDiffableDataSource<Section, Diary>?
    var diary: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryListView = DiaryListView()
        self.view = diaryListView
        convertDiaryData()
        configureDiaryListDataSource()
        snapShot()
        setupNavigationBar()
    }
    
    func convertDiaryData() {
        guard let data = NSDataAsset(name: "sample")?.data else {
            return
        }
        diary = DecodeManager.decodeDiaryData(data) ?? []
    }
    
    func configureDiaryListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<DiaryCell, Diary> {
            cell, indexPath, diary in
            cell.configureDiaryCellLayout()
            cell.titleLabel.text = self.diary[indexPath.item].title
            cell.dateLabel.text = self.diary[indexPath.item].createdAt.timeZoneDateFormat
            cell.previewLabel.text = self.diary[indexPath.item].body
        }
        
        guard let diaryListView = diaryListView,
            let diaryListView = diaryListView.diaryListView else { return }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: diaryListView,
                                                        cellProvider: {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                         for: indexPath,
                                                         item: itemIdentifier)
        })
    }
    
    func snapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Diary>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diary)
        dataSource?.apply(snapshot)
    }
}

extension ViewController {
    enum Section {
        case main
    }
}

extension ViewController {
    private func setupNavigationBar() {
        self.navigationItem.title = "일기장"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let addBarButtonItem = UIBarButtonItem(title: "+",
                                               style: .plain,
                                               target: self,
                                               action: #selector(addDiary))
        
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    @objc func addDiary() {
        
    }
}
