//  MainViewController.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import UIKit

final class MainViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DiaryData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiaryData>
    
    private lazy var dataSource = configureDataSource()
    private lazy var mainDiaryView = MainDiaryView()
    private var diaryDatas: [DiaryData] = []
    
    private let networkManager = NetworkManager.shared
    private let coreDataManager = CoreDataManager.shared
    private let imageCacheManager = NSCache<NSString, UIImage>()
    
    enum Section {
        case main
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
        applySnapshot(animatingDifferences: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainDiaryView
        self.mainDiaryView.delegate = self
        mainDiaryView.collectionView.delegate = self
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        self.title = "일기장"
        let appearence = UINavigationBarAppearance()
        appearence.backgroundColor = .systemGray5
        self.navigationController?.navigationBar.standardAppearance = appearence
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearence
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add,
                                           target: self,
                                           action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    private func setupData() {
        let result = coreDataManager.fetchData()
        switch result {
        case .success(let data):
            diaryDatas = data
        case .failure(let error):
            self.showCustomAlert(alertText: error.localizedDescription,
                                 alertMessage: error.errorDescription ?? "",
                                 useAction: true,
                                 completion: nil)
        }
    }
    
    @objc private func addButtonTapped() {
        let addViewController = EditViewController()
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = diaryDatas[indexPath.item]
        let currentDiary = CurrentDiary(id: item.id,
                                        contentText: item.contentText,
                                        createdAt: item.createdAt)
        let addViewController = EditViewController(currentDiaryData: currentDiary)
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
}

// MARK: - DiffableDataSource And Snapshot
extension MainViewController {
    private func configureDataSource() -> DataSource {
        let cellRegistration = UICollectionView
            .CellRegistration<CustomListCell, DiaryData> { cell, indexPath, diaryData in
                
                cell.setupData(diaryData)
                cell.accessories = [.disclosureIndicator()]
                
                if let iconID = diaryData.weather?.iconID {
                    let cacheKey = NSString(string: iconID)
                    
                    if let cacheImage = self.imageCacheManager.object(forKey: cacheKey) {
                        cell.setupImage(image: cacheImage)
                    } else {
                        let url = NetworkRequest.loadImage(id: iconID).generateURL()
                        
                        self.networkManager.fetchImage(url: url) { image in
                            DispatchQueue.main.async {
                                if indexPath == self.mainDiaryView.collectionView.indexPath(
                                    for: cell
                                ) {
                                    self.imageCacheManager.setObject(image, forKey: cacheKey)
                                    cell.setupImage(image: image)
                                }
                            }
                        }
                    }
                }
            }
        let dataSource = DataSource(
            collectionView: mainDiaryView.collectionView
        ) { collectionView, indexPath, diaryData in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: diaryData)
        }
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaryDatas)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - Swipe
extension MainViewController: SwipeConfigurable {
    func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath,
              let id = diaryDatas[indexPath.item].id else { return nil }
        
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: deleteActionTitle) { [weak self] _, _, _ in
            
            do {
                try self?.coreDataManager.deleteData(id: id)
            } catch {
                guard let error = error as? DataError else { return }
                self?.showCustomAlert(alertText: error.localizedDescription,
                                     alertMessage: "삭제 실패하였습니다.",
                                     useAction: true,
                                     completion: nil)
            }
            self?.setupData()
            self?.applySnapshot(animatingDifferences: true)
        }
        
        let item = diaryDatas[indexPath.item]
        let currentData = CurrentDiary(id: item.id,
                                       contentText: item.contentText,
                                       createdAt: item.createdAt)
        let shareActionTitle = NSLocalizedString("Share", comment: "Share action title")
        let shareAction = UIContextualAction(style: .normal,
                                             title: shareActionTitle) { [weak self] _, _, _ in
            self?.moveToActivityView(data: currentData)
        }
        deleteAction.backgroundColor = .systemPink
        shareAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}
