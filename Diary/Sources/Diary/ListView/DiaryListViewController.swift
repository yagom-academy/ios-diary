//
//  Diary - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DiaryListViewController: UIViewController {
    
    // MARK: - Name Spaces
    
    private enum Section {
        case main
    }
    
    private enum LogicNameSpace {
        static let diaryCellIdentifier = "DiaryListCell"
    }
    
    // MARK: - Properties
    
    private let diaryDataManager = DiaryDataManager()
    
    private var diaryListDiffableDataSource: UICollectionViewDiffableDataSource<Section, DiaryItem>?
    
    private lazy var diaryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createListLayout()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var diaryCoreData: [DiaryItem] {
        guard let diaryCoreData = DiaryCoreDataManager.shared.fetchAllDiary() else {
            return [DiaryItem]()
        }
        
        return diaryCoreData
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootViewUI()
        configureCollectionView()
        configureDiaryListDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyDiaryEntitySnapshot()
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
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        configuration.trailingSwipeActionsConfigurationProvider = { index in
            let shareAction = UIContextualAction(style: .normal, title: "Share") { _, _, _ in
                let sharedDiaryItem = self.createTextViewContent(from: self.diaryCoreData[index.row])
                let activitiViewController = UIActivityViewController(
                    activityItems: [sharedDiaryItem],
                    applicationActivities: nil
                )
                self.present(activitiViewController, animated: true)
            }
            
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
                let deleteAlert: UIAlertController = {
                    let deleteAlert = UIAlertController(
                        title: "정말 삭제할까요?",
                        message: "삭제 후 복구는 불가능합니다.",
                        preferredStyle: .alert
                    )

                    let cancel = UIAlertAction(
                        title: "취소",
                        style: .cancel
                    )
                    
                    let delete = UIAlertAction(
                        title: "삭제",
                        style: .destructive,
                        handler: { action in
                            DiaryCoreDataManager.shared.delete(diaryItem: self.diaryCoreData[index.row])
                            self.applyDiaryEntitySnapshot()
                        }
                    )
                    
                    [cancel, delete].forEach {
                        deleteAlert.addAction($0)
                    }

                    return deleteAlert
                }()
                
                self.present(deleteAlert, animated: true)
            }
            
            return UISwipeActionsConfiguration(actions: [shareAction, deleteAction])
        }
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    // MARK: - Configuring Model
    
    func createTextViewContent(from diaryItem: DiaryItem) -> String {
        return """
        \(diaryItem.title)
        
        \(diaryItem.body)
        """
    }
    
    func applyDiaryEntitySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaryCoreData)
        diaryListDiffableDataSource?.apply(snapshot)
    }
    
    @objc func rightBarButtonDidTap() {
        pushDiaryCreateViewController()
    }
    
    func pushDiaryUpdateViewController(with diaryItem: DiaryItem) {
        let diaryDetailViewController = DiaryUpdateViewController(with: diaryItem)
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func pushDiaryCreateViewController() {
        let diaryDetailViewController = DiaryCreateViewController()
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func configureDiaryListDataSource() {
        diaryCollectionView.register(
            DiaryListCollectionViewCell.self,
            forCellWithReuseIdentifier: LogicNameSpace.diaryCellIdentifier
        )
        
        self.diaryListDiffableDataSource = UICollectionViewDiffableDataSource<Section,DiaryItem>(
            collectionView: self.diaryCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                guard let diaryCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: LogicNameSpace.diaryCellIdentifier,
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
        guard let diaryItem = diaryListDiffableDataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        pushDiaryUpdateViewController(with: diaryItem)
    }
}
