//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
//
//  Created by 애종, 애쉬 on 2022/12/20.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<DiarySection, Diary>?
    private var diary: [Diary] = []
    
    private enum DiarySection: Hashable {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureListContents()
    }
    
    private func configureView() {
        self.configureNavigationBar()
        self.configureCollectionView()
    }
    
    private func configureListContents() {
        self.decodeJsonData()
        self.configureDataSource()
        self.applySnapshot()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "일기장"
        self.configureAddButton()
    }
    
    private func configureAddButton() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add,
                                      target: self,
                                      action: #selector(self.pressAddButton))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    @objc private func pressAddButton() {
        let addDiaryViewController = AddDiaryViewController()
        self.navigationController?.pushViewController(addDiaryViewController, animated: true)
    }
    
    private func configureCollectionView() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func decodeJsonData() {
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "sample") else {
            let errorAlert = ErrorAlert.shared.showErrorAlert(title: DiaryError.dataAssetLoadFailed.alertTitle,
                                                              message: DiaryError.dataAssetLoadFailed.alertMessage,
                                                              actionTitle: "확인")
            present(errorAlert, animated: true)
            return
        }
        
        JSONDecoder().decode(data: dataAsset.data) { (result: Result<[Diary], DiaryError>) in
            switch result {
            case .success(let decodedDiary):
                self.diary = decodedDiary
            case .failure(let error):
                let errorAlert = ErrorAlert.shared.showErrorAlert(title: error.alertTitle,
                                                                  message: error.alertMessage,
                                                                  actionTitle: "확인")
                self.present(errorAlert, animated: true)
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
