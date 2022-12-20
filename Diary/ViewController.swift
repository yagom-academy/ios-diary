//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    var diaryListView: DiaryListView?
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>?

    override func viewDidLoad() {
        super.viewDidLoad()
        diaryListView = DiaryListView()
        self.view = diaryListView
        configureDiaryListDataSource()
        snapShot()
    }
    
    func configureDiaryListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<DiaryCell, Int> {
            cell, indexPath, itemIdentifier in
            cell.configureDiaryCellLayout()
            cell.titleLabel.text = "Test"
            cell.dateLabel.text = "TestData"
            cell.previewLabel.text = "previewTestText"
            cell.titleLabel.backgroundColor = .blue
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(1...10))
        dataSource?.apply(snapshot)
    }
}

extension ViewController {
    enum Section {
        case main
    }
}
