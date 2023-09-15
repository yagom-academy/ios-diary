//
//  Diary - MainViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Private Property
    private let dataManager: DataManager
    
    private let compositor: DiaryContentCompositor
    private let currentFormatter = CurrentDateFormatter()
    private var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    private var diaries: [Diary] = []
    
    // MARK: - Lifecycle
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.compositor = DiaryContentCompositor()
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
        self.diaries = dataManager.fetch()
        collectionView.reloadData()
    }
    
    // MARK: - Private Method(Navigation)
    
    private func configureNavigation() {
        self.navigationItem.title = "일기장"
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(tapAddButton)
        )
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
    
    // MARK: - private Method(SwipeAction)
    
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
        return UIContextualAction(
            style: .destructive,
            title: "delete",
            handler: { [weak self] _, _, _ in
                self?.deleteDiaryAlert(diary: diary)
            }
        )
    }
    
    private func shareAction(diary: Diary) -> UIContextualAction {
        return UIContextualAction(
            style: .normal,
            title: "share",
            handler: { [weak self] _, _, completionHaldler in
                guard let diaryContent = self?.compositor.composite(
                    title: diary.title,
                    content: diary.content
                ) else { return }
                
                let activityView = UIActivityViewController(
                    activityItems: [diaryContent],
                    applicationActivities: nil
                )
                
                activityView.completionWithItemsHandler = { (_, success, _, _) in
                    if success {
                        completionHaldler(true)
                    } else {
                        completionHaldler(false)
                    }
                }
                self?.present(activityView, animated: true)
            }
        )
    }
    
    private func deleteDiaryAlert(diary: Diary) {
        let deleteAlert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.dataManager.delete(diary)
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
