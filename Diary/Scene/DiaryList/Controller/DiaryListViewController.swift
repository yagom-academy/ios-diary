//
//  Diary - DiaryListViewController.swift
//  Created by bonf, bard.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DiaryListViewController: UIViewController {
    // MARK: - properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Design.moonImage)
        imageView.tintColor = .lightGray
        
        return imageView
    }()
    
    private var diaryCollectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Diary>?
    private var diaryCoreManager: DiaryCoreDataManager?
    
    // MARK: - life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDataSource()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        diaryCoreManager = DiaryCoreDataManager(with: .shared)
        diaryCoreManager?.fetch()
    }
    
    // MARK: - functions
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupNavigationController()
        diaryCollectionView = setupCollectionView(frame: .zero,
                                                  collectionViewLayout: setupLayout())
        diaryCollectionView?.delegate = self
    }
    
    private func setupNavigationController() {
        navigationItem.title = Design.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Design.plusButton),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightBarButtonItemDidTap))
        
        setupAppearanceMode()
    }
    
    private func setupAppearanceMode() {
        let switchControl = UISwitch()
        switchControl.onTintColor = .white
        switchControl.setOn(false, animated: true)
        switchControl.addTarget(self,
                                action: #selector(switchValueDidChange(sender:)),
                                for: .valueChanged)
        
        self.navigationItem.leftBarButtonItems =
        [
            UIBarButtonItem(customView: imageView),
            UIBarButtonItem.init(customView: switchControl)
        ]
    }
    
    private func setupCollectionView(frame: CGRect, collectionViewLayout: UICollectionViewLayout) -> UICollectionView {
        let collectionView = UICollectionView(frame: frame,
                                              collectionViewLayout: collectionViewLayout)
        
        view.addSubview(collectionView)
        setupCollectionViewConstraints(collectionView)
        
        return collectionView
    }
    
    private func setupCollectionViewConstraints(_ collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)

        listConfiguration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
          guard let self = self else { return nil }
            
          let deleteActionHandler: UIContextualAction.Handler = { action, view, completion in

              completion(true)
              guard let diaryList = self.diaryCoreManager?.diaryList else { return }
              self.diaryCoreManager?.delete(diaryList[indexPath.row])
          }
            
            let deleteAction = UIContextualAction(style: .normal,
                                                 title: nil,
                                                 handler: deleteActionHandler)
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            
            
            let shareAction = UIContextualAction(style: .normal,
                                                 title: nil) { action, view, competion in
                competion(true)
                let item = self.diaryCoreManager?.diaryList.get(index: indexPath.row)
                
                let shareActivitView = UIActivityViewController(activityItems: [item as Any], applicationActivities: nil)
                self.present(shareActivitView, animated: true)
            }
            
            shareAction.backgroundColor = .systemBlue
            shareAction.image = UIImage(systemName: "square.and.arrow.up")
            
            return UISwipeActionsConfiguration(actions: [shareAction, deleteAction])
        }
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)

        return listLayout
    }
    
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<DiaryListCollectionViewCell, Diary>
        {
            (cell, indexPath, identifier) in
            cell.setupCellProperties(with: identifier)
        }
        
        guard let collectionView = diaryCollectionView else { return }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Diary>(collectionView: collectionView)
        {
            (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: identifier)
        }
    }
    
    private func setupSnapshot(with model: [Diary]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Diary>()
        snapshot.appendSections([.main])
        snapshot.appendItems(model)
        
        dataSource?.apply(snapshot)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidReceiveData(_:)),
                                               name: .didReceiveData,
                                               object: nil)
    }
    
    // MARK: - objc functions
    
    @objc private func onDidReceiveData(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.setupDataSource()
            self?.setupSnapshot(with: self?.diaryCoreManager?.diaryList ?? [])
        }
    }
    
    @objc func switchValueDidChange(sender: UISwitch) {
        guard #available(iOS 13.0, *) else { return }
        
        let appDelegate = UIApplication.shared.windows.first
        
        if sender.isOn {
            appDelegate?.overrideUserInterfaceStyle = .dark
            sender.onTintColor = .lightGray
            sender.thumbTintColor = .black
            
            imageView.tintColor = .systemYellow
        } else {
            appDelegate?.overrideUserInterfaceStyle = .light
            sender.thumbTintColor = .white
            
            imageView.tintColor = .lightGray
        }
    }
    
    @objc private func rightBarButtonItemDidTap() {
        let diaryRegistrationViewController = DiaryRegistrationViewController()
        navigationController?.pushViewController(diaryRegistrationViewController, animated: true)
        
        let date = Date()
        diaryRegistrationViewController.navigationItem.title = date.convertToCurrentTime()
    }
}

extension DiaryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let diaryDetailViewController = DiaryDetailViewController()
        guard let diaryCoreData = diaryCoreManager else { return }
        
        diaryDetailViewController.setupData(diaryCoreData.diaryList[indexPath.row])
        
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}

private enum Design {
    static let moonImage = "moon.fill"
    static let navigationTitle = "일기장"
    static let plusButton = "plus"
    static let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .absolute(44))
    static let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .absolute(44))
    static let enumInterGroupSpacing = 8.0
    static let enumContentInsets = NSDirectionalEdgeInsets(top: 10,
                                                           leading: 10,
                                                           bottom: 10,
                                                           trailing: 10)
}

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
}
