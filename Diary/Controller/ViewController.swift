//
//  Diary - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    static let identifier = "MainView"
    var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
        return collectionView
    }()
    var diaryList: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDiaryList()
        configureListLayout()
        assignDataSourceAndDelegate()
        setView()
        registerCustomCell()
        configureCollectionViewConstraint()
        configureNavigation()
    }
    
    private func setView() {
        self.view.addSubview(collectionView)
    }
    
    private func setDiaryList() {
        guard let asset = NSDataAsset(name: "sample") else {
            return
        }
        
        let decoder = JSONDecoder()
        do {
            diaryList = try decoder.decode([Diary].self, from: asset.data)
        } catch {
            return
        }
    }
    
    private func configureListLayout() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    private func assignDataSourceAndDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureCollectionViewConstraint() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func registerCustomCell() {
        collectionView.register(DiaryCell.self, forCellWithReuseIdentifier: DiaryCell.id)
    }
    
    private func configureNavigation() {
        self.navigationItem.title = "일기장"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func add() {
        let diaryViewController = DiaryViewController()
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCell.id, for: indexPath) as? DiaryCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(diary: diaryList[indexPath.row])
        return cell
    }
    
}
