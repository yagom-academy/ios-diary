//
//  Diary - DiaryListViewController.swift
//  Created by bonf, bard. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryListViewController: UIViewController {
    
    // MARK: - properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "moon.fill")
        imageView.tintColor = .lightGray
        
        return imageView
    }()
    
    private var diaryCollectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, JSONModel>?
    private var diaryDelegate: DataSendable?
    private var diaryInfomation: [JSONModel] = []
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDataSource()
        setupSnapshot(with: fetch())
        diaryCollectionView?.delegate = self
    }
    
    // MARK: - functions
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationController()
        diaryCollectionView = setupCollectionView(frame: .zero,
                                             collectionViewLayout: setupLayout())
    }
    
    private func setupNavigationController() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
        
        setupAppearanceMode()
    }
    
    private func setupAppearanceMode() {
        let switchControl = UISwitch()
        switchControl.onTintColor = .white
        switchControl.setOn(false, animated: true)
        switchControl.addTarget(self,
                                action: #selector(switchValueDidChange(sender:)),
                                for: .valueChanged)
        
        self.navigationItem.leftBarButtonItems =
        [
            UIBarButtonItem(customView: imageView),
            UIBarButtonItem.init(customView: switchControl)
        ]
    }
    
    private func setupCollectionView(frame: CGRect, collectionViewLayout: UICollectionViewLayout) -> UICollectionView {
        let collectionView = UICollectionView(frame: frame,
                                              collectionViewLayout: collectionViewLayout)
        
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
                                              heightDimension: .estimated(44))
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
        {
            (cell, indexPath, identifier) in
            cell.setupCellProperties(with: identifier)
            self.diaryInfomation.append(identifier)
        }
        
        guard let collectionView = diaryCollectionView else { return }
        
        dataSource = UICollectionViewDiffableDataSource<Section, JSONModel>(collectionView: collectionView)
        {
            (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            
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
    
    // MARK: - objc functions
    
    @objc func switchValueDidChange(sender: UISwitch) {
        guard #available(iOS 13.0, *) else { return }
        
        let appDelegate = UIApplication.shared.windows.first
        
        if sender.isOn {
            appDelegate?.overrideUserInterfaceStyle = .dark
            sender.onTintColor = .lightGray
            sender.thumbTintColor = .black
            
            imageView.tintColor = .systemYellow
        } else {
            appDelegate?.overrideUserInterfaceStyle = .light
            sender.thumbTintColor = .white
            
            imageView.tintColor = .lightGray
        }
    }
}

extension DiaryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let diaryDetailViewController = DiaryDetailViewController()
        diaryDelegate = diaryDetailViewController
        self.diaryDelegate?.setupData(diaryInfomation[indexPath.row])
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}
