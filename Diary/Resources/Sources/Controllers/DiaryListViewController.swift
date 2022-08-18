//
//  Diary - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DiaryListViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    // MARK: - Properties
    
    private let dataManager = DataManager()
    
    private lazy var diaryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createListLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var diaryListDiffableDataSource: UICollectionViewDiffableDataSource<Section, DiaryItem>?
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootViewUI()
        configureCollectionView()
        configureDiaryListDataSource()
        fetchData()
    }
}

// MARK: - Private Methods

private extension DiaryListViewController {
    
    func configureRootViewUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(rightBarButtonDidTap)
        )
    }
    
    @objc func rightBarButtonDidTap() {
        let diaryDetailViewController = DiaryDetailViewController()
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(70.0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureCollectionView() {
        view.addSubview(diaryCollectionView)
        
        diaryCollectionView.delegate = self
        
        NSLayoutConstraint.activate([
            diaryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureDiaryListDataSource() {
        diaryCollectionView.register(DiaryListCollectionViewCell.self, forCellWithReuseIdentifier: "DiaryListCell")
        
        self.diaryListDiffableDataSource = UICollectionViewDiffableDataSource<Section,DiaryItem>(
            collectionView: self.diaryCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                guard let diaryCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "DiaryListCell",
                    for: indexPath) as? DiaryListCollectionViewCell else {
                    return UICollectionViewCell()
                }
                diaryCell.setupCellData(diary: itemIdentifier)
                return diaryCell
            })
    }
    
    func fetchData() {
        guard let parsedData = dataManager.parse(dataManager.temporarySampleData!.data, into: [DiaryItem].self) else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(parsedData)
        self.diaryListDiffableDataSource?.apply(snapshot)
    }
}

// MARK: - DiaryListViewController Delegate

extension DiaryListViewController: UICollectionViewDelegate {
    
}
