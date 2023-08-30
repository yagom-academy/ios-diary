//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private var diaryEntity: [DiaryEntity]?
    
    private let collectionView: UICollectionView = {
        let configuration: UICollectionLayoutListConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(DiaryCollectionViewListCell.self, forCellWithReuseIdentifier: DiaryCollectionViewListCell.identifier)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDiaryEntity()
        configureCollectionView()
        configureNavigation()
        configureUI()
        configureLayout()
    }
    
    private func decodeData() throws -> [DiaryEntity]? {
        guard let asset = NSDataAsset(name: "sample") else {
            throw DecodingError.decodingFailure
        }
        
        let decodedData = try? JSONDecoder().decode([DiaryEntity].self, from: asset.data)
        diaryEntity = decodedData
        
        return decodedData
    }
    
    private func updateDiaryEntity() {
        do {
            diaryEntity = try decodeData()
        } catch DecodingError.decodingFailure {
            print(DecodingError.decodingFailure.description)
        } catch {
            print(error)
        }
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureNavigation() {
        let addDiary: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(hitCreateNewDiaryButton))
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

    @objc private func hitCreateNewDiaryButton() {
        let newDiaryViewController: NewDiaryViewController = NewDiaryViewController()
        navigationController?.pushViewController(newDiaryViewController, animated: true)
    }
}

extension DiaryListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let diaryEntity = diaryEntity else {
            return 0
        }
        
        return diaryEntity.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewListCell.identifier, for: indexPath) as? DiaryCollectionViewListCell else {
            return UICollectionViewCell()
        }
        
        guard let diaryIndex = diaryEntity?[index: indexPath.item] else {
            return cell
        }
        
        cell.configureLabel(with: diaryIndex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let diaryEntity = diaryEntity else {
            return
        }
        
        guard let diaryIndex = diaryEntity[index: indexPath.item] else {
            return
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let diaryDetailViewController: DiaryDetailViewController = DiaryDetailViewController(diaryEntity: diaryIndex)
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}
