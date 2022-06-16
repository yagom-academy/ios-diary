//
//  Diary - ViewController.swift
//  Created by Donnie, OneTool. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    
    private enum Constants {
        static let navigationBarTitle = "일기장"
        static let navigationBarRightPlusButton = "plus"
    }
    
    private var diaryData: [DiaryModel] = []
    private lazy var mainView = MainView(frame: view.frame)
    private var listLayout: UICollectionViewCompositionalLayout {
        var configure = UICollectionLayoutListConfiguration(appearance: .plain)
        configure.showsSeparators = true
        configure.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: configure)
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        setNavigationBarTitle()
        setNavigationBarRightPlusButton()
        updateDiaryData()
        registerCollectionViewCell()
        setCollectionViewLayout()
    }
    
    private func updateDiaryData() {
        guard let content = NSDataAsset(name: "sample"),
                let decodedData: [DiaryModel] = try? JSONDecoder().decode([DiaryModel].self, from: content.data) else { return
        }
        diaryData = decodedData
    }
}

// MARK: - Method

extension MainViewController {
    
    private func setNavigationBarTitle() {
        navigationController?.navigationBar.topItem?.title = Constants.navigationBarTitle
    }
    
    private func setNavigationBarRightPlusButton() {
        let plusButton = UIBarButtonItem(
            image: UIImage(systemName: Constants.navigationBarRightPlusButton),
            style: .plain,
            target: self,
            action: #selector(navigationBarRightPlusButtonTapped)
        )
        navigationItem.rightBarButtonItem = plusButton
    }
    
    private func setCollectionViewLayout() {
        mainView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func registerCollectionViewCell() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
    }
}

// MARK: - Action Method

extension MainViewController {

    @objc private func navigationBarRightPlusButtonTapped() {
        
    }
}

// MARK: - CollectionView Method

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return diaryData.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListCell.identifier,
            for: indexPath) as? ListCell else {
            return UICollectionViewCell()
        }
        cell.accessories = [.disclosureIndicator()]
        cell.titleLabel.text = diaryData[indexPath.row].title
        cell.dateLabel.text = diaryData[indexPath.row].createdAt?.formattedDate
        cell.descriptionLabel.text = diaryData[indexPath.row].body
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(diaryData: diaryData[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
