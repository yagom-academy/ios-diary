//
//  Diary - DiaryListViewController.swift
//  Created by bonf, bard. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryListViewController: UIViewController {
    
    // MARK: - properties
    
    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, JSONModel>?
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationController()
        collectionView = setupCollectionView(frame: .zero,
                                             collectionViewLayout: setupLayout())
        setupDataSource()
        setupSnapshot(with: fetch())
    }
    
    // MARK: - functions
    
    private func setupNavigationController() {
        navigationItem.title = "일기장"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
    }
    
    private func setupCollectionView(frame: CGRect, collectionViewLayout: UICollectionViewLayout) -> UICollectionView {
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        
        view.addSubview(collectionView)
        setupCollectionViewConstraints(collectionView)
        
        return collectionView
    }
    
    private func setupCollectionViewConstraints(_ collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                        leading: 10,
                                                        bottom: 10,
                                                        trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func fetch() -> [JSONModel] {
        guard let data = NSDataAsset(name: "sample")?.data,
              let decodedData = try? JSONDecoder().decode([JSONModel].self, from: data)
        else { return [] }
        
        return decodedData
    }
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<DiaryListCollectionViewCell, JSONModel>
        { (cell, indexPath, identifier) in
            cell.setupCellProperties(with: identifier)
        }
        
        guard let collectionView = collectionView else { return }
        
        dataSource = UICollectionViewDiffableDataSource<Section, JSONModel>(collectionView: collectionView)
        { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: identifier)
        }
    }
    
    private func setupSnapshot(with jsonModel: [JSONModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, JSONModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(jsonModel)
        dataSource?.apply(snapshot)
    }
}
