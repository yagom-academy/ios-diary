//
//  Diary - MainViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Private Property
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var diaryList: [Diary] = []
    
    private var persistance: Persistance
    
    // MARK: - Lifecycle
    
    init(persistance: Persistance) {
        self.persistance = persistance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        setDiaryList()
        configureCollectionView()
    }
    
    // MARK: - Private Method
    
    private func configureNavigation() {
        self.navigationItem.title = "일기장"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func tapAddButton() {
        let diaryViewController = DiaryViewController()
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func setDiaryList() { }
    
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
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
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
}

// MARK: - Extension

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
