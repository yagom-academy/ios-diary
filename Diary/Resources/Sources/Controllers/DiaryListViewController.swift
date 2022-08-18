//
//  Diary - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DiaryListViewController: UIViewController {
    
    private enum Section {
        case main
    }
    
    // MARK: - Properties
    
    private let dataManager = DataManager()
    
    private var diaryListDiffableDataSource: UICollectionViewDiffableDataSource<Section, DiaryItem>?
    
    private lazy var diaryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createListLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
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
    
    // MARK: - Configuring UI
    
    func configureRootViewUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(rightBarButtonDidTap)
        )
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
    
    // MARK: - Configuring Model
    
    func fetchData() {
        guard let parsedData = dataManager.parse(dataManager.temporarySampleData!.data, into: [DiaryItem].self) else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(parsedData)
        self.diaryListDiffableDataSource?.apply(snapshot)
    }
    
    @objc func rightBarButtonDidTap() {
        pushDiaryDetailViewController()
    }
    
    func pushDiaryDetailViewController(with diaryItem: DiaryItem? = nil) {
        let diaryDetailViewController = DiaryDetailViewController()
        diaryDetailViewController.recieveData(diaryItem)
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
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
}

// MARK: - DiaryListViewController Delegate

extension DiaryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let diaryItem = diaryListDiffableDataSource?.itemIdentifier(for: indexPath)
        pushDiaryDetailViewController(with: diaryItem)
    }
}
