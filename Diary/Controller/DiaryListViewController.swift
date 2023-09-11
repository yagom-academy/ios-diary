//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class DiaryListViewController: UIViewController {
    var diaries: [Diary] = []
    
    private lazy var collectionView: UICollectionView = {
        var configuration: UICollectionLayoutListConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let delete = UIContextualAction(style: .destructive, title: "Delete") {[weak self] _, _, completionHandler in
                guard let uuid = CoreDataManager.shared.fetch(Diary.fetchRequest())[index: indexPath.item]?.identifier else { return }
                
                CoreDataManager.shared.deleteDiary(uuid)
                self?.diaries = CoreDataManager.shared.fetch(Diary.fetchRequest())
                self?.collectionView.reloadData()
                
                completionHandler(true)
            }
            
            let share = UIContextualAction(style: .normal, title: "Share") {_, _, completionHandler in
                
                completionHandler(true)
            }
            
            return UISwipeActionsConfiguration(actions: [delete, share])
        }
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(DiaryCollectionViewListCell.self, forCellWithReuseIdentifier: DiaryCollectionViewListCell.identifier)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavigation()
        configureUI()
        configureLayout()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.diaries = CoreDataManager.shared.fetch(Diary.fetchRequest())
        diaries.forEach { diary in
            if diary.body == nil {
                CoreDataManager.shared.deleteDiary(diary.identifier!)
            }
        }
        self.diaries = CoreDataManager.shared.fetch(Diary.fetchRequest())
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        // diffableDatasource
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
        let uuid: String = UUID().uuidString
        let newDiaryViewController: NewDiaryViewController = NewDiaryViewController(uuid: uuid)
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: CoreDataManager.shared.context) else {
            return
        }
        let object = NSManagedObject(entity: entity, insertInto: CoreDataManager.shared.context)
        object.setValue("타이틀틀", forKey: "title")
        object.setValue(DateFormatter.today, forKey: "createdAt")
        object.setValue(uuid, forKey: "identifier")
        
        
        navigationController?.pushViewController(newDiaryViewController, animated: true)
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
        
        guard let uuid = diaries[safe: indexPath.item]?.identifier else {
            return
        }
        print(uuid)
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let diaryDetailViewController: DiaryDetailViewController = DiaryDetailViewController(uuid: uuid)
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
}
