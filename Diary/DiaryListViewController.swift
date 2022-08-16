//
//  Diary - DiaryListViewController.swift
//  Created by bonf, bard. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryListViewController: UIViewController {
    var collectionView: UICollectionView?
    private let collectionViewCellRegistration = UICollectionView.CellRegistration<DiaryListCollectionViewCell, String> { cell,indexPath,itemIdentifier in
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        collectionView = setupCollectionView(frame: .zero,
                                             collectionViewLayout: setupLayout())
        collectionView?.backgroundColor = .orange
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    private func setupCollectionView(frame: CGRect, collectionViewLayout: UICollectionViewLayout) -> UICollectionView {
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DiaryListCollectionViewCell.self,
                                forCellWithReuseIdentifier: DiaryListCollectionViewCell.identifier)
        view.addSubview(collectionView)
        setupCollectionViewConstraints(collectionView)
        
        return collectionView
    }
    
    private func setupCollectionViewConstraints(_ collectionView: UICollectionView) {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                        leading: 10,
                                                        bottom: 10,
                                                        trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension DiaryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueConfiguredReusableCell(using: collectionViewCellRegistration,
                                                                      for: indexPath,
                                                                      item: "cell")
        
        return cell
    }
}

extension DiaryListViewController: UICollectionViewDelegate {
    
}
