//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
//
//  Created by 애종, 애쉬 on 2022/12/20.
// 

import UIKit
import CoreData
import CoreLocation

final class DiaryListViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.trailingSwipeActionsConfigurationProvider = self.makeSwipeAction
        let collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        return collectionView
    }()
    
    private let listCellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, DiaryModel> {
        (cell, indexPath, diary) in
        cell.configureContents(with: diary)
        cell.accessories = [.disclosureIndicator()]
    }
    
    private lazy var listCellProvider = {
        (collectionView: UICollectionView, indexPath: IndexPath, diary: DiaryModel) -> UICollectionViewCell? in
        
        return collectionView.dequeueConfiguredReusableCell(using: self.listCellRegistration,
                                                            for: indexPath,
                                                            item: diary)
    }
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<DiarySection, DiaryModel>(
        collectionView: self.collectionView, cellProvider: self.listCellProvider)
    
    private enum DiarySection: Hashable {
        case main
    }
    
    private let weatherNetworkManager: NetworkManageable
    private var locationManager: CLLocationManager = CLLocationManager()
    
    private var currentLatitude: String = ""
    private var currentLongtitude: String = ""
    
    init(weatherNetworkManager: NetworkManageable) {
        self.weatherNetworkManager = weatherNetworkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchDiary()
    }
    
    private func configureView() {
        self.configureNavigationBar()
        self.configureCollectionView()
    }
    
    private func configureLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "일기장"
        self.configureAddButton()
    }
    
    private func configureAddButton() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add,
                                      target: self,
                                      action: #selector(self.pressAddButton))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    @objc private func pressAddButton() {
        self.weatherNetworkManager.getJSONData(url: self.getWeatherURL(),
                                               type: WeatherModel.self) { [weak self] result in
            switch result {
            case .success(let data):
                guard let weatherMain = data.weather.first?.main,
                      let weatherIconID = data.weather.first?.icon else { return }
                
                self?.insertDefaultDiary(DiaryModel(weatherMain: weatherMain,
                                                    weatherIconID: weatherIconID))
            case .failure(let error):
                if self?.locationManager.authorizationStatus == .some(.authorizedWhenInUse),
                   self?.locationManager.authorizationStatus == .some(.authorizedAlways) {
                    DispatchQueue.main.async {
                        self?.present(ErrorAlert.shared.showErrorAlert(title: error.alertTitle,
                                                                       message: error.alertMessage,
                                                                       actionTitle: "확인"), animated: true)
                    }
                }
                
                self?.insertDefaultDiary(DiaryModel())
            }
            
            DispatchQueue.main.async {
                self?.moveToEditView()
            }
        }
    }
    
    private func getWeatherURL() -> URL? {
        guard let latitude: CLLocationDegrees = locationManager.location?.coordinate.latitude,
              let longtitude: CLLocationDegrees = locationManager.location?.coordinate.longitude else {
            return nil
        }
        
        let roundedLatitude = String(format: "%.2f", latitude)
        let roundedLongitude = String(format: "%.2f", longtitude)
        
        guard let url = APIManager.currentWeather(lat: roundedLatitude, lon: roundedLongitude).urlComponents.url else {
            return nil
        }
        
        return url
    }
    
    private func insertDefaultDiary(_ diary: DiaryModel) {
        do {
            try CoreDataMananger.shared.insert(diary: diary)
        } catch {
            self.present(ErrorAlert.shared.showErrorAlert(title: DiaryError.saveContextFailed.alertTitle,
                                                          message: DiaryError.saveContextFailed.alertMessage,
                                                          actionTitle: "확인"),
                         animated: true)
        }
    }
    
    private func moveToEditView() {
        do {
            let currentDiaryModel = try CoreDataMananger.shared.fetchLastObject()
            let editDiaryViewController = EditDiaryViewController(diaryModel: currentDiaryModel)
            
            self.navigationController?.pushViewController(editDiaryViewController, animated: true)
        } catch {
            self.present(ErrorAlert.shared.showErrorAlert(title: DiaryError.fetchFailed.alertTitle,
                                                          message: DiaryError.fetchFailed.alertMessage,
                                                          actionTitle: "확인"),
                         animated: true)
        }
    }
    
    private func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchDiary() {
        do {
            let diaries: [Diary] = try CoreDataMananger.shared.fetchDiaries()
            var diaryModels: [DiaryModel] = []
            
            diaries.forEach {
                diaryModels.append(DiaryModel(id: $0.objectID,
                                              title: $0.title ?? "",
                                              body: $0.body ?? "",
                                              weatherMain: $0.weatherMain ?? "",
                                              weatherIconID: $0.weatherIconID ?? "",
                                              createdAt: $0.createdAt))
            }
            
            self.applySnapshot(with: diaryModels)
        } catch {
            self.present(ErrorAlert.shared.showErrorAlert(title: DiaryError.fetchFailed.alertTitle,
                                                          message: DiaryError.fetchFailed.alertMessage,
                                                          actionTitle: "확인"),
                         animated: true)
        }
    }
    
    private func applySnapshot(with diaries: [DiaryModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<DiarySection, DiaryModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaries)
        self.dataSource.apply(snapshot)
    }
}

extension DiaryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let diaryItem: DiaryModel = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let editDiaryViewController = EditDiaryViewController(diaryModel: diaryItem)
        
        self.navigationController?.pushViewController(editDiaryViewController, animated: true)
    }
    
    private func makeSwipeAction(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath,
              let diaryOfIndexPath = self.dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        let deleteAction = makeDeleteAction(diaryOfIndexPath)
        let shareAction = makeShareAction(diaryOfIndexPath)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    private func makeDeleteAction(_ diaryWillDelete: DiaryModel) -> UIContextualAction {
        UIContextualAction(style: .destructive,
                           title: "delete") { [weak self] _, _, _ in
            do {
                try CoreDataMananger.shared.delete(diary: diaryWillDelete)
                
                self?.delete(diary: diaryWillDelete)
                
            } catch {
                switch error {
                case DiaryError.deleteFailed:
                    self?.present(ErrorAlert.shared.showErrorAlert(title: DiaryError.deleteFailed.alertTitle,
                                                                   message: DiaryError.deleteFailed.alertMessage,
                                                                   actionTitle: "확인"),
                                  animated: true)
                case DiaryError.saveContextFailed:
                    self?.present(ErrorAlert.shared.showErrorAlert(title: DiaryError.saveContextFailed.alertTitle,
                                                                   message: DiaryError.saveContextFailed.alertMessage,
                                                                   actionTitle: "확인"),
                                  animated: true)
                default:
                    break
                }
            }
        }
    }
    
    private func delete(diary: DiaryModel) {
        var snapshot = self.dataSource.snapshot()
        
        snapshot.deleteItems([diary])
        self.dataSource.apply(snapshot)
    }
    
    private func makeShareAction(_ diaryWillShare: DiaryModel) -> UIContextualAction {
        UIContextualAction(style: .normal,
                           title: "share") { [weak self] _, _, completion in
            var objectsToShare: [String] = []
            objectsToShare.append(diaryWillShare.title + "\n" + diaryWillShare.body)
            
            self?.showActivityContoller(objectsToShare)
            completion(true)
        }
    }
}
