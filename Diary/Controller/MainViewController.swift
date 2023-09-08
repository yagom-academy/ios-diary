//
//  Diary - MainViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Private Property
    private let dataManager: DataManager
    
    private let currentFormatter = CurrentDateFormatter()
    private var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    private var diaries: [Diary] = []
    
    // MARK: - Lifecycle
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readDiaries()
    }
    
    // MARK: - CRUD
    
    private func readDiaries() {
        do {
            self.diaries = try dataManager.container.viewContext.fetch(Diary.fetchRequest())
            collectionView.reloadData()
        } catch {
            print("다이어리를 가져오는데 실패했습니다.")
        }
    }
    
    // MARK: - Private Method(Navigation)
    
    private func configureNavigation() {
        self.navigationItem.title = "일기장"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func tapAddButton() {
        let diaryViewController = DiaryViewController(
            dataManager: dataManager,
            formatter: currentFormatter
        )
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    // MARK: - Private Method(CollectionView)
    
    private func configureCollectionView() {
        setupCollectionView()
        layoutCollectionView()
        constraintCollectionView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DiaryCell.self, forCellWithReuseIdentifier: DiaryCell.id)
    }
    
    private func layoutCollectionView() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            return self?.configureSwipeAction(for: indexPath)
        }
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    private func constraintCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureSwipeAction(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let diary = diaries[indexPath.row]
        let delete = deleteAction(diary: diary)
        let share = shareAction(diary: diary)
        share.backgroundColor = .systemBlue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, share])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
    
    private func deleteAction(diary: Diary) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] _, _, _ in
            self?.deleteDiaryAlert(diary: diary)
        }
        
        return deleteAction
    }
    
    private func shareAction(diary: Diary) -> UIContextualAction {
        let shareAction = UIContextualAction(style: .normal, title: "share") { [weak self] _, _, completionHaldler in
            
            guard let title = diary.title, let content = diary.content else {
                return
            }
            
            let diaryContent = title + "\n\n" + content
            let activityView = UIActivityViewController(activityItems: [diaryContent],
                                                        applicationActivities: nil)
            
            activityView.completionWithItemsHandler = { (_, success, _, _) in
                if success {
                    completionHaldler(true)
                } else {
                    completionHaldler(false)
                }
            }
            self?.present(activityView, animated: true)
        }
        
        return shareAction
    }
    
    private func deleteDiaryAlert(diary: Diary) {
        let deleteAlert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.dataManager.container.viewContext.delete(diary)
            self?.dataManager.saveContext()
            self?.readDiaries()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        deleteAlert.addAction(cancel)
        deleteAlert.addAction(delete)
        
        present(deleteAlert, animated: true)
    }
}

// MARK: - CollectionView Delegate, DataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DiaryCell.id,
            for: indexPath
        ) as? DiaryCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(diary: diaries[indexPath.row], formatter: currentFormatter)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let diary = diaries[indexPath.row]
        let diaryViewController = DiaryViewController(
            dataManager: dataManager,
            formatter: currentFormatter,
            diary: diary
        )
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
}
