//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DiaryData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiaryData>
    
    private lazy var dataSource = configureDataSource()
    private var diaryDatas: [DiaryData] = []
    
    private let mainDiaryView = MainDiaryView()
    private let coreDataManager = CoreDataManager.shared
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainDiaryView
        setNavigationBar()
        setupData()
        applySnapshot()
    }
    
    private func setNavigationBar() {
        self.title = "일기장"
        let appearence = UINavigationBarAppearance()
        appearence.backgroundColor = .systemGray5
        self.navigationController?.navigationBar.standardAppearance = appearence
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add,
                                           target: self,
                                           action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func setupData() {
        diaryDatas = coreDataManager.fetchData()
    }
    
    @objc private func addButtonTapped() {
        let addViewController = AddViewController()
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
}

// MARK: - DiffableDataSource And Snapshot
extension MainViewController {
    private func configureDataSource() -> DataSource {
        let cellRegistration = UICollectionView
            .CellRegistration<DiaryCollectionViewCell, DiaryData> { cell, _, diaryData in
                cell.bindData(diaryData)
            }
        
        let dataSource = DataSource(
            collectionView: mainDiaryView.collectionView
        ) { collectionView, indexPath, diaryData in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: diaryData)
        }
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaryDatas)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
