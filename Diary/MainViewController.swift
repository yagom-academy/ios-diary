//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Diary>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Diary>
    
    private lazy var dataSource = configureDataSource()
    private var diaryDatas: [Diary] = []
    
    private let mainDiaryView = MainDiaryView()
    
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
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func setupData() {
        let decodeManager = DecoderManager<Diary>()
        let result = decodeManager.decodeJsonData("sample")
        
        switch result {
        case .success(let datas):
            diaryDatas = datas
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    @objc private func addButtonTapped() {
        let detailViewController = DetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: - DiffableDataSource And Snapshot
extension MainViewController {
    private func configureDataSource() -> DataSource {
        let cellRegistration = UICollectionView
            .CellRegistration<DiaryCollectionViewCell, Diary> { cell, indexPath, diaryData in
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
