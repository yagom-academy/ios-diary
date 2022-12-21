//
//  Diary - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    private var diaryListView: DiaryListView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Diary>?
    private var diary: [Diary] = []
    
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
        let cellRegistration = UICollectionView.CellRegistration<DiaryCell, Diary> {
            cell, indexPath, diary in
            cell.configureDiaryCellLayout()
            cell.titleLabel.text = self.diary[indexPath.item].title
            cell.dateLabel.text = self.diary[indexPath.item].createdDate
            cell.previewLabel.text = self.diary[indexPath.item].body
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, Diary>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diary)
        dataSource?.apply(snapshot)
    }
}

extension ViewController {
    
    private enum Section {
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
    
    @objc private func addDiary() {

    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DiaryDetailViewController(diary: diary[indexPath.item])
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
