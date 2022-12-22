//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
//
//  Created by 애종, 애쉬 on 2022/12/20.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private lazy var collectionView: UICollectionView = UICollectionView(frame: view.bounds,
                                                                         collectionViewLayout: createListLayout())
    private var dataSource: UICollectionViewDiffableDataSource<DiarySection, Diary>?
    private var diary: [Diary] = []
    
    enum DiarySection: Hashable {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureListContents()
    }
    
    private func configureView() {
        configureNavigationBar()
        configureCollectionView()
    }
    
    private func configureListContents() {
        decodeJsonData()
        configureDataSource()
        applySnapshot()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "일기장"
        configureAddButton()
    }
    
    private func configureAddButton() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add,
                                      target: self,
                                      action: #selector(pressAddButton))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    @objc private func pressAddButton() {
        let addDiaryViewController = AddDiaryViewController()
        self.navigationController?.pushViewController(addDiaryViewController, animated: true)
    }
    
    private func configureCollectionView() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func decodeJsonData() {
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "sample") else {
            self.showErrorAlert(title: ErrorType.dataAssetLoadFailed.alertTitle,
                                message: ErrorType.dataAssetLoadFailed.alertMessage)
            return
        }
        
        JSONDecoder().decode(data: dataAsset.data) { (result: Result<[Diary], ErrorType>) in
            switch result {
            case .success(let decodedDiary):
                self.diary = decodedDiary
            case .failure(let error):
                self.showErrorAlert(title: error.alertTitle, message: error.alertMessage)
            }
        }
    }
    
    private func configureDataSource() {
        let listCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, Diary> {
            (cell, indexPath, diary) in
            cell.configureContents(with: diary)
            cell.accessories = [.disclosureIndicator()]
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<DiarySection, Diary>(collectionView: collectionView) {
            collectionView, indexPath, diary in
            
            return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration,
                                                                for: indexPath,
                                                                item: diary)
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<DiarySection, Diary>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diary)
        self.dataSource?.apply(snapshot)
    }
}
