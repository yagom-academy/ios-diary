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
    
    private let listCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, DiaryModel> {
        (cell, indexPath, diary) in
        cell.configureContents(with: diary)
        cell.accessories = [.disclosureIndicator()]
    }
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<DiarySection, DiaryModel>(
        collectionView: self.collectionView) {
            collectionView, indexPath, diary in
            
            return collectionView.dequeueConfiguredReusableCell(using: self.listCellRegistration,
                                                                for: indexPath,
                                                                item: diary)
        }
    
    private enum DiarySection: Hashable {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDiary()
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
        
        do {
            let currentDiaryModel = try CoreDataMananger.shared.fetchLastObject()
            let editDiaryViewController = EditDiaryViewController(diaryModel: currentDiaryModel)
            
            self.navigationController?.pushViewController(editDiaryViewController, animated: true)
        } catch {
            self.present(ErrorAlert.shared.showErrorAlert(title: DiaryError.fetchFailed.alertTitle,
                                                          message: DiaryError.fetchFailed.alertMessage,
                                                          actionTitle: "확인"),
                         animated: true)
        }
    }
    
    private func configureCollectionView() {
        self.configureDataSource()
        self.collectionView.delegate = self
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
    
    private func fetchDiary() {
        do {
            let diaries: [Diary] = try CoreDataMananger.shared.fetchDiaries()
            var diaryModels: [DiaryModel] = []
            
            diaries.forEach {
                diaryModels.append(DiaryModel(id: $0.objectID,
                                              title: $0.title ?? "",
                                              body: $0.body ?? "",
                                              createdAt: $0.createdAt))
            }
            
            self.applySnapshot(with: diaryModels)
        } catch {
            self.present(ErrorAlert.shared.showErrorAlert(title: DiaryError.fetchFailed.alertTitle,
                                                          message: DiaryError.fetchFailed.alertMessage,
                                                          actionTitle: "확인"),
                         animated: true)
        }
    }
    
    private func applySnapshot(with diaries: [DiaryModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<DiarySection, DiaryModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaries)
        self.dataSource.apply(snapshot)
    }
}

extension DiaryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let diaryItem: DiaryModel = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let editDiaryViewController = EditDiaryViewController(diaryModel: diaryItem)
        
        self.navigationController?.pushViewController(editDiaryViewController, animated: true)
    }
    
    private func makeSwipeAction(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath,
              let diaryOfIndexPath = self.dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        let deleteAction = makeDeleteAction(diaryOfIndexPath)
        let shareAction = makeShareAction(diaryOfIndexPath)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    func makeDeleteAction(_ diaryWillDelete: DiaryModel) -> UIContextualAction {
        UIContextualAction(style: .destructive,
                           title: "delete") { _, _, _ in
            do {
                try CoreDataMananger.shared.deleteDiary(diaryWillDelete)
                
                var snapshot = self.dataSource.snapshot()
                snapshot.deleteItems([diaryWillDelete])
                self.dataSource.apply(snapshot)
            } catch {
                self.present(ErrorAlert.shared.showErrorAlert(title: DiaryError.deleteFailed.alertTitle,
                                                              message: DiaryError.deleteFailed.alertMessage,
                                                              actionTitle: "확인"),
                             animated: true)
            }
        }
    }
    
    func makeShareAction(_ diaryWillShare: DiaryModel) -> UIContextualAction {
        UIContextualAction(style: .normal,
                           title: "share") { _, _, completion in
            var objectsToShare: [String] = []
            objectsToShare.append(diaryWillShare.title + "\n" + diaryWillShare.body)
            
            self.showActivityContoller(objectsToShare)
            completion(true)
        }
    }
}
