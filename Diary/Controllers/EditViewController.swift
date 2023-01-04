//
//  AddViewController.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit
import CoreLocation

protocol KeyboardActionSavable: AnyObject {
    func saveWhenHideKeyboard()
}

final class EditViewController: UIViewController {
    private let networkManager = NetworkManager.shared
    private let coreDataManager = CoreDataManager.shared
    private let currentDate = Date()
    
    private var currentDiaryData = CurrentDiary()
    private var locationManager: CLLocationManager?
    private lazy var editView = EditDiaryView(currentDiaryData: currentDiaryData)
    
    init(currentDiaryData: CurrentDiary = CurrentDiary()) {
        super.init(nibName: nil, bundle: nil)
        self.currentDiaryData = currentDiaryData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.checkToSave()
        self.checkToDelete()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editView
        setupCoreLocationManager()
        self.editView.delegate = self
        setNavigation()
        addNotification()
    }
    
    private func setNavigation() {
        if let date = currentDiaryData.createdAt {
            self.title = Formatter.changeCustomDate(date)
        } else {
            self.title = Formatter.changeCustomDate(currentDate)
        }
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(optionButtonTapped))
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func addNotification() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(saveWhenBackground),
                                                   name: UIScene.willDeactivateNotification,
                                                   object: nil)
        } else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(saveWhenBackground),
                                                   name: UIApplication.willResignActiveNotification,
                                                   object: nil)
        }
    }
}

// MARK: - Associate Save, Delete Logic
extension EditViewController {
    @objc func saveWhenBackground() {
        self.checkToSave()
    }
    
    private func checkToSave() {
        let data = editView.packageData()
        currentDiaryData.contentText = data
        if currentDiaryData.id != nil {
            guard let id = currentDiaryData.id, data != "" else { return }
            do {
                try coreDataManager.updateData(id: id, contentText: data)
            } catch {
                guard let error = error as? DataError else { return }
                self.showCustomAlert(alertText: error.localizedDescription,
                                     alertMessage: error.errorDescription ?? "",
                                     useAction: true,
                                     completion: nil)
            }
        } else {
            do {
                currentDiaryData.createdAt = currentDate
                currentDiaryData.id = try coreDataManager.saveData(data: currentDiaryData)
            } catch {
                guard let error = error as? DataError else { return }
                self.showCustomAlert(alertText: error.localizedDescription,
                                     alertMessage: error.errorDescription ?? "",
                                     useAction: true,
                                     completion: nil)
            }
        }
    }
    
    private func checkToDelete() {
        guard let contentText = currentDiaryData.contentText?.trimmingCharacters(
            in: .whitespacesAndNewlines) else { return }
        
        if let id = currentDiaryData.id, contentText.count == .zero {
            do {
                try coreDataManager.deleteData(id: id)
            } catch {
                guard let error = error as? DataError else { return }
                self.showCustomAlert(alertText: error.localizedDescription,
                                     alertMessage: "삭제 실패하였습니다.",
                                     useAction: true,
                                     completion: nil)
            }
        }
    }
}

// MARK: - Action
extension EditViewController {
    @objc private func optionButtonTapped() {
        self.checkToSave()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.moveToActivityView(data: self.currentDiaryData)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            guard let id = self.currentDiaryData.id else { return }
            
            do {
                try self.coreDataManager.deleteData(id: id)
            } catch {
                guard let error = error as? DataError else { return }
                self.showCustomAlert(alertText: error.localizedDescription,
                                     alertMessage: "삭제 실패하였습니다.",
                                     useAction: true,
                                     completion: nil)
            }
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        [shareAction, deleteAction, cancelAction].forEach {
            alert.addAction($0)
        }
        self.present(alert, animated: true)
    }
}

extension EditViewController: KeyboardActionSavable {
    func saveWhenHideKeyboard() {
        self.checkToSave()
    }
}

// MARK: - Core Location
extension EditViewController: CLLocationManagerDelegate {
    private func setupCoreLocationManager() {
        if currentDiaryData.id == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            let url = NetworkRequest.fetchData(lat: String(coordinate.latitude),
                                               lon: String(coordinate.longitude)).generateURL()
            saveWeatherData(url: url)
            
        }
        locationManager?.stopUpdatingLocation()
    }
}

// MARK: - Network
extension EditViewController {
    private func saveWeatherData(url: URL?) {
        guard let url = url else { return }
        networkManager.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                guard let data = data.weather.first else { return }
                self.currentDiaryData.main = data.main
                self.currentDiaryData.iconID = data.icon
            case .failure(let error):
                self.showCustomAlert(alertText: error.localizedDescription,
                                     alertMessage: "위치 정보를 사용하지 못하였습니다.",
                                     useAction: true,
                                     completion: nil)
            }
        }
    }
}
