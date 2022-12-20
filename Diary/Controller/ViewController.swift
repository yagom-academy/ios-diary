//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
//
//  Created by 애종, 애쉬 on 2022/12/20.
// 

import UIKit

final class ViewController: UIViewController {
    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Diary>?
    private var diary: Diary?

    enum Section: Hashable {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "일기장"
        configureAddButton()
    }
    
    private func configureAddButton() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: createListLayout())
        guard let collectionView = collectionView else { return }
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureDataSource() {
        guard let collectionView = self.collectionView else { return }
        
        let listCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, Diary> {
            (cell, indexPath, diary) in
            cell.configureContents(with: diary)
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<Section, Diary>(collectionView: collectionView) {
            collectionView, indexPath, diary in
            
            return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration,
                                                                for: indexPath,
                                                                item: diary)
        }
    }
}
