//
//  Diary - ViewController.swift
//  Created by rilla, songjun.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCompositionalListLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Diary>!
    
    private var diaries: [Diary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureLayout()
        configureViewController()
        configureDataSource()
        
        let decodedResult = DecodeManager().decodeJSON(fileName: "sample", type: [Diary].self)
        diaries = try? verifyResult(result: decodedResult)
        print("d")
    }
    
    private func verifyResult<T, E: Error>(result: Result<T, E>) throws -> T? {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func configureViewController() {
        view.backgroundColor = .white
        self.title = "일기장"

        let buttonItem: UIBarButtonItem = {
            let button = UIButton()
            
            button.setImage(UIImage(systemName: "plus"), for: .normal)
            button.addTarget(self,
                             action: #selector(presentAddingDiaryPage),
                             for: .touchUpInside)
            let barButton = UIBarButtonItem(customView: button)
            
            return barButton
        }()
        
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    @objc private func presentAddingDiaryPage() {
        performQuery()
    }
}

// MARK: - CollectionView
enum Section: CaseIterable {
    case main
}

extension ViewController {
    private func configureCollectionView() {

        configureDataSource()
        //performQuery()
    }
    
    private func configureCompositionalListLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration
        <DiaryCollectionViewCell, Diary> { (cell, indexPath, diary) in
            cell.configureCell(diary: diary)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Diary>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Diary) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func performQuery() {
        guard diaries != nil else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Diary>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaries!)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
