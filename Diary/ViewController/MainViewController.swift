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
    private let paser = Parser()
    private var listLayout: UICollectionViewCompositionalLayout {
        var configure = UICollectionLayoutListConfiguration(appearance: .plain)
        configure.showsSeparators = true
        configure.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: configure)
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: listLayout
    )
    
    override func viewDidLoad() {
        self.view = view
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setNavigationBarTitle()
        setNavigationBarRightPlusButton()
        updateDiaryData()
        registerCollectionViewCell()
        setCollectionViewLayout()
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
        view.addSubview(collectionView)
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
        collectionView.register(
            ListCell.self,
            forCellWithReuseIdentifier: ListCell.identifier
        )
    }
    
    private func updateDiaryData() {
        do {
            let decodedData = try paser.parse()
            diaryData = decodedData
        } catch DiaryError.invalidFileName{
            print("invalid file name")
        } catch DiaryError.decodeError {
            print("decode error")
        } catch {
            print("invalid error : \(error)")
        }
    }
}

// MARK: - Action Method

extension MainViewController {
    
    @objc private func navigationBarRightPlusButtonTapped() {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(
            registerViewController,
            animated: true
        )
    }
}

// MARK: - CollectionView Method

extension MainViewController: UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {
    
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
        cell.updateLabels(diaryModel: diaryData[indexPath.row])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let data = diaryData[safe: indexPath.row] else { return }
        let detailViewController = DetailViewController(
            diaryData: data
        )
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}
