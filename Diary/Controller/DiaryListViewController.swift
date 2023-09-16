//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    var diaries: [Diary] = []
    
    private lazy var collectionView: UICollectionView = {
        var configuration: UICollectionLayoutListConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        swipeAction(&configuration)
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(DiaryCollectionViewListCell.self, forCellWithReuseIdentifier: DiaryCollectionViewListCell.identifier)
        
        return view
    }()
    
    func swipeAction(_ configuration: inout UICollectionLayoutListConfiguration) {
            configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
                let uuid = CoreDataManager.shared.fetchAllDiaries()[indexPath.item].identifier
                
                let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
                    self?.collectionView.performBatchUpdates {
                        CoreDataManager.shared.delete(diary: uuid)
                        self?.collectionView.deleteItems(at: [indexPath])
                        self?.diaries = CoreDataManager.shared.fetchAllDiaries()
                    }
                    
                    completionHandler(true)
                }
                let title = self.diaries[indexPath.item].title
                let share = UIContextualAction(style: .normal, title: "Share") { [weak self] _, _, completionHandler in
                    self?.showActivityView(title)
                    completionHandler(true)
                }
                
                return UISwipeActionsConfiguration(actions: [delete, share])
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigation()
        configureUI()
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.diaries = CoreDataManager.shared.fetchAllDiaries()
        
        diaries.forEach { diary in
            if diary.title == nil && diary.body == nil {
                CoreDataManager.shared.delete(diary: diary.identifier)
            }
        }
        self.diaries = CoreDataManager.shared.fetchAllDiaries()
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureNavigation() {
        let addDiary: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(createNewDiaryButtonTapped))
        self.navigationItem.rightBarButtonItem = addDiary
        navigationItem.title = "일기장"
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
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
    
    @objc private func createNewDiaryButtonTapped() {
        let uuid: UUID = UUID()
        CoreDataManager.shared.create(diary: uuid)
        
        guard let diary: Diary = CoreDataManager.shared.fetchSingleDiary(by: uuid)[safe: 0] else {
            return
        }
        
        let diaryDetailViewController: DiaryDetailViewController = DiaryDetailViewController(diary: diary)
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func showActivityView(_ diary: String?) {
        let activityViewController = UIActivityViewController(activityItems: [diary as Any], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}

extension DiaryListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewListCell.identifier, for: indexPath) as? DiaryCollectionViewListCell else {
            return UICollectionViewCell()
        }
        
        guard let diary = diaries[safe: indexPath.item] else {
            return cell
        }
        
        cell.configureLabel(with: diary)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let diary = diaries[safe: indexPath.item] else {
            return
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let diaryDetailViewController: DiaryDetailViewController = DiaryDetailViewController(diary: diary)
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}
