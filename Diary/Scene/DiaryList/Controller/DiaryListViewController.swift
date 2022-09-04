//
//  Diary - DiaryListViewController.swift
//  Created by bonf, bard.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class DiaryListViewController: UIViewController {
    // MARK: - properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Design.moonImage)
        imageView.tintColor = .lightGray
        
        return imageView
    }()
    
    private let diaryCoreManager = DiaryCoreDataManager(with: .shared)
    private let locationManager = CLLocationManager()
    private let searchController = UISearchController(searchResultsController: nil)
    private var diaryCollectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Diary>?
    private var icon: String?
    
    // MARK: - life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDataSource()
        addObserver()
        setupLocationManager()
        setupSearchConroller()
    }
    
    private func setupSearchConroller() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        diaryCoreManager.fetch()
        updateDiary(with: searchController)
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
              
              self.diaryCoreManager.delete(self.diaryCoreManager.diaryList[indexPath.row])
          }
            
            let deleteAction = UIContextualAction(style: .normal,
                                                 title: nil,
                                                 handler: deleteActionHandler)
            deleteAction.image = UIImage(systemName: Design.trash)
            deleteAction.backgroundColor = .systemRed
            
            let shareAction = UIContextualAction(style: .normal,
                                                 title: nil) { action, view, competion in
                competion(true)
                let item = self.diaryCoreManager.diaryList.get(index: indexPath.row)
                
                let shareActivitView = UIActivityViewController(activityItems: [item as Any], applicationActivities: nil)
                self.present(shareActivitView, animated: true)
            }
            
            shareAction.backgroundColor = .systemBlue
            shareAction.image = UIImage(systemName: Design.squareAndArrowUp)
            
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
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func updateDiary(with searchController: UISearchController) {
        diaryCoreManager.fetch()
        
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        let diaryList = (self.diaryCoreManager.diaryList.filter {
              $0.title.lowercased().contains(text) || $0.body.lowercased().contains(text)
          })
        
        diaryCoreManager.searchDiary(diaryList)
        
        if searchController.searchBar.text?.isEmpty == true {
            diaryCoreManager.fetch()
        }
    }
    
    // MARK: - objc functions
    
    @objc private func onDidReceiveData(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.setupDataSource()
            self?.setupSnapshot(with: self?.diaryCoreManager.diaryList ?? [])
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
        diaryRegistrationViewController.setupDiary(icon: icon)

        navigationController?.pushViewController(diaryRegistrationViewController, animated: true)
        
        let date = Date()
        diaryRegistrationViewController.navigationItem.title = date.convertToCurrentTime()
    }
}

extension DiaryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let diaryDetailViewController = DiaryDetailViewController()
        
        diaryDetailViewController.setupData(diaryCoreManager.diaryList[indexPath.row])
        
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let heightRemainHeight = contentHeight - yOffset

        let frameHeight = scrollView.frame.height
        guard let location = locationManager.location?.coordinate else { return }

        print("frameHeight: \(frameHeight)")
        print("heightRemainHeight: \(heightRemainHeight)")
        if heightRemainHeight < frameHeight {
            requestWeather(location)
        }
    }
    
    private func requestWeather(_ locValue: CLLocationCoordinate2D) {
        let weatherRequest = DiaryRequest(baseURL: URLHost.openWeather.url,
                                            query: [URLQueryItem(name: Design.latitude, value: "\(locValue.latitude)"),
                                                    URLQueryItem(name: Design.longitude, value: "\(locValue.longitude)"),
                                                    Design.IDQueryItem],
                                            path: URLAdditionalPath.weather)
        let weatherSession = DiaryURLSession()
        
        weatherSession.dataTask(with: weatherRequest) { (result: Result<WeatherModel, Error>) in
            switch result {
            case .success(let success):
                self.icon = success.weather.last?.icon
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

extension DiaryListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateDiary(with: searchController)
    }
}

private enum Design {
    static let moonImage = "moon.fill"
    static let navigationTitle = "일기장"
    static let plusButton = "plus"
    static let trash = "trash"
    static let squareAndArrowUp = "square.and.arrow.up"
    static let latitude = "lat"
    static let longitude = "lon"
    static let IDQueryItem = URLQueryItem(name: "appid", value: "63722b736b97508775be46f7cf76cb85")
}

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
}
