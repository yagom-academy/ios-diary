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
    private let collectionView: UICollectionView = {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
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
    
    private func fetchDiary() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            guard let diary = try context.fetch(Diary.fetchRequest()) as? [Diary] else { return }
            var diaries: [DiaryModel] = []
            
            diary.forEach {
                diaries.append(DiaryModel(title: $0.title ?? "", body: $0.body ?? "", createdAt: $0.createdAt))
            }
            applySnapshot(with: diaries)
        } catch {
            print(error.localizedDescription)
        }
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
        let addDiaryViewController = AddDiaryViewController()
        self.navigationController?.pushViewController(addDiaryViewController, animated: true)
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
        let editDiaryViewController = EditDiaryViewController()
        
        guard let diaryItem: DiaryModel = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        editDiaryViewController.configureView(with: diaryItem)
        
        self.navigationController?.pushViewController(editDiaryViewController, animated: true)
    }
}
