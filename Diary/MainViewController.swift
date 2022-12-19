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
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    func setupData() {
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
        
    }
}

//MARK: - DiffableDataSource And Snapshot
extension MainViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: mainDiaryView.collectionView) { collectionView, indexPath, diary in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? DiaryCollectionViewCell else {
                let errorCell = UICollectionViewCell()
                return errorCell
            }
            //TODO: -  Cell Data Insert
            cell.bindData(diary)
            return cell
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
