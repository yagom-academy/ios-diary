//
//  Diary - ViewController.swift
//  Created by Donnie, OneTool. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

fileprivate extension DiaryConstants {
    static let navigationBarTitle = "일기장"
    static let navigationBarRightPlusButton = "plus"
    static let cellSwipeShareButton = "square.and.arrow.up.on.square"
    static let cellSwipeDeleteButton = "trash"
}

final class MainViewController: UIViewController {
    
    private let persistenceManager = PersistenceManager.shared
    private var diaryData: [DiaryModel] = []
    private var listLayout: UICollectionViewCompositionalLayout {
        var configure = UICollectionLayoutListConfiguration(appearance: .plain)
        configure.showsSeparators = true
        configure.backgroundColor = .clear
        configure.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            let share = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
                guard let diaryTitle = self?.diaryData[indexPath.row].title else {
                    return
                }
                let activityViewController = UIActivityViewController(
                    activityItems: [diaryTitle],
                    applicationActivities: nil
                )
                self?.present(activityViewController, animated: true)
                completion(true)
            }
            share.image = UIImage(systemName: DiaryConstants.cellSwipeShareButton)
            share.backgroundColor = .systemBlue
            
            let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
                guard let diaryData = self?.diaryData[indexPath.row] else {
                    return
                }
                self?.persistenceManager.delete(diary: diaryData)
                self?.diaryData.remove(at: indexPath.row)
                self?.collectionView.deleteItems(at: [indexPath])
                completion(true)
            }
            delete.image = UIImage(systemName: DiaryConstants.cellSwipeDeleteButton)
            return UISwipeActionsConfiguration(actions: [delete, share])
        }
        return UICollectionViewCompositionalLayout.list(using: configure)
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: listLayout
    )
}

// MARK: - View Life Cycle Method

extension MainViewController {
    
    override func viewDidLoad() {
        self.view = view
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavigationBarTitle()
        setNavigationBarRightPlusButton()
        registerCollectionViewCell()
        setCollectionViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDiaryData()
    }
}

// MARK: - Method

extension MainViewController {
    
    private func setNavigationBarTitle() {
        navigationController?.navigationBar.topItem?.title = DiaryConstants.navigationBarTitle
    }
    
    private func setNavigationBarRightPlusButton() {
        let plusButton = UIBarButtonItem(
            image: UIImage(systemName: DiaryConstants.navigationBarRightPlusButton),
            style: .plain,
            target: self,
            action: #selector(navigationBarRightPlusButtonTapped)
        )
        navigationItem.rightBarButtonItem = plusButton
    }
    
    private func setCollectionViewLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func registerCollectionViewCell() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            ListCell.self,
            forCellWithReuseIdentifier: ListCell.identifier
        )
    }
    
    private func fetchDiaryData() {
        diaryData = persistenceManager.fetch().reversed()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Action Method

extension MainViewController {
    
    @objc private func navigationBarRightPlusButtonTapped() {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(
            registerViewController,
            animated: true
        )
    }
}

// MARK: - CollectionView Method

extension MainViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return diaryData.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListCell.identifier,
            for: indexPath) as? ListCell else {
            return UICollectionViewCell()
        }
        cell.accessories = [.disclosureIndicator()]
        cell.updateLabels(diaryModel: diaryData[indexPath.row])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let data = diaryData[safe: indexPath.row] else { return }
        let detailViewController = DetailViewController(
            diaryData: data
        )
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}
