//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
//
//  Created by 애종, 애쉬 on 2022/12/20.
// 

import UIKit
import CoreData

final class DiaryListViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.trailingSwipeActionsConfigurationProvider = self.makeSwipeAction
        let collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<DiarySection, DiaryModel>?
    
    private enum DiarySection: Hashable {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureDataSource()
        self.collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDiary()
    }
    
    private func makeSwipeAction(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath,
              let diaryWillDelete = dataSource?.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "delete") { _, _, _ in
            CoreDataMananger.shared.deleteDiary(diaryWillDelete)
            self.fetchDiary()
        }
        
        let shareAction = UIContextualAction(style: .normal,
                                              title: "share") { _, _, _ in
            var objectsToShare = [String]()
            objectsToShare.append(diaryWillDelete.title + "\n" + diaryWillDelete.body)
            
            self.showActivityContoller(objectsToShare)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    private func fetchDiary() {
        let diaries: [Diary] = CoreDataMananger.shared.fetchDiaries()
        var diaryModels: [DiaryModel] = []
        
        diaries.forEach {
            diaryModels.append(DiaryModel(id: $0.objectID,
                                          title: $0.title ?? "",
                                          body: $0.body ?? "",
                                          createdAt: $0.createdAt))
        }
        
        applySnapshot(with: diaryModels)
    }
    
    private func configureView() {
        self.configureNavigationBar()
        self.configureCollectionView()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "일기장"
        self.configureAddButton()
    }
    
    private func configureAddButton() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add,
                                      target: self,
                                      action: #selector(self.pressAddButton))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    @objc private func pressAddButton() {
        CoreDataMananger.shared.insertDiary(DiaryModel())
        
        let editDiaryViewController = EditDiaryViewController()
        let currentDiaryModel = CoreDataMananger.shared.fetchLastObject()
        
        editDiaryViewController.configureView(with: currentDiaryModel)
        self.navigationController?.pushViewController(editDiaryViewController, animated: true)
    }
    
    private func configureCollectionView() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        let listCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, DiaryModel> {
            (cell, indexPath, diary) in
            cell.configureContents(with: diary)
            cell.accessories = [.disclosureIndicator()]
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<DiarySection, DiaryModel>(collectionView: collectionView) {
            collectionView, indexPath, diary in
            
            return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration,
                                                                for: indexPath,
                                                                item: diary)
        }
    }
    
    private func applySnapshot(with diaries: [DiaryModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<DiarySection, DiaryModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaries)
        self.dataSource?.apply(snapshot)
    }
}

extension DiaryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let editDiaryViewController = EditDiaryViewController()
        
        guard let diaryItem: DiaryModel = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        editDiaryViewController.configureView(with: diaryItem)
        
        self.navigationController?.pushViewController(editDiaryViewController, animated: true)
    }
}
