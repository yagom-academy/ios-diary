//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class DiaryListViewController: UIViewController {
    private var diaryEntity: [DiaryEntity]?
    var cellCount: Int = 0
    var diaries: [Diary] = []
    
    private let collectionView: UICollectionView = {
        let configuration: UICollectionLayoutListConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
//        configuration.leadingSwipeActionsConfigurationProvider = { }
        
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
        do {
            let data = try CoreDataManager.shared.context.fetch(Diary.fetchRequest())
            cellCount = data.count
            self.diaries = data
        } catch {
            print(error.localizedDescription)
        }
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
        let newDiaryViewController: NewDiaryViewController = NewDiaryViewController()
        navigationController?.pushViewController(newDiaryViewController, animated: true)
    }
}

extension DiaryListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewListCell.identifier, for: indexPath) as? DiaryCollectionViewListCell else {
            return UICollectionViewCell()
        }
        
        guard let diary = diaries[index: indexPath.item] else {
            return cell
        }
        
        cell.configureLabel(with: diary)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let uuid = diaries[index: indexPath.item]?.identifier else {
            return
        }
        print(uuid)
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let diaryDetailViewController: DiaryDetailViewController = DiaryDetailViewController(uuid: uuid)
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}
