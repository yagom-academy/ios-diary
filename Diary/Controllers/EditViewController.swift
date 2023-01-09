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
    
    private var iconImage: UIImage?
    private var currentDiaryData = CurrentDiary()
    private var currentWeatherData = CurrentWeather()
    private var locationManager: CLLocationManager?
    private lazy var editView = EditDiaryView(currentDiaryData: currentDiaryData)
    
    private let navigationLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var navigationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        return imageView
    }()
    
    private lazy var navigationStackView = UIStackView(subview: [navigationImageView,
                                                                 navigationLabel],
                                                       spacing: 5,
                                                       axis: .horizontal,
                                                       alignment: .center,
                                                       distribution: .fill)
    
    init(currentDiaryData: CurrentDiary = CurrentDiary(), iconImage: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.currentDiaryData = currentDiaryData
        self.iconImage = iconImage
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
        setupNavigationBar()
        addNotification()
    }
    
    private func setupNavigationBar() {
        if let date = currentDiaryData.createdAt {
            navigationLabel.text = Formatter.changeCustomDate(date)
        } else {
            navigationLabel.text = Formatter.changeCustomDate(currentDate)
        }
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(optionButtonTapped))
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.titleView = navigationStackView
        
        guard let iconImage = iconImage else { return }
        navigationImageView.image = iconImage
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
                currentDiaryData.id = try coreDataManager.saveData(diaryData: currentDiaryData,
                                                                   weatherData: currentWeatherData)
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
        
        [shareAction, deleteAction, cancelAction].forEach(alert.addAction(_:))
        
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
            
            switch locationManager?.authorizationStatus {
            case .denied:
                showLocationAlert()
            case .notDetermined, .restricted:
                locationManager?.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                break
            default:
                break
            }
            
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
    
    private func showLocationAlert() {
        let alert = UIAlertController(title: "위치 권한 요청",
                                      message: "위치 권한을 허용 하시겠습니까?",
                                      preferredStyle: .alert)
        let conformAction = UIAlertAction(title: "허용", style: .default) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingURL)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)

        [cancelAction, conformAction].forEach(alert.addAction(_:))
        
        self.present(alert, animated: true)
    }
}

// MARK: - Network
extension EditViewController {
    private func saveWeatherData(url: URL?) {
        guard let url = url else { return }
        networkManager.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                self.convertWeatherData(data: data)
            case .failure(let error):
                self.showCustomAlert(alertText: error.localizedDescription,
                                     alertMessage: "위치 정보를 사용하지 못하였습니다.",
                                     useAction: true,
                                     completion: nil)
            }
        }
    }
    
    private func convertWeatherData(data: Data) {
        let decoder = DecoderManager<WeatherAPIData>()
        
        let data = decoder.decodeData(data)
        switch data {
        case .success(let data):
            guard let weatherData = data.weather.first else { return }
            self.currentWeatherData.iconID = weatherData.icon
            self.currentWeatherData.main = weatherData.main
            fetchIconImage(currentWeatherData: currentWeatherData) { image in
                DispatchQueue.main.async {
                    self.iconImage = image
                    self.navigationImageView.image = image
                }
            }
        case .failure(let error):
            self.showCustomAlert(alertText: error.localizedDescription,
                                 alertMessage: "디코딩 에러발생하였습니다..",
                                 useAction: true,
                                 completion: nil)
        }
    }
    
    private func fetchIconImage(currentWeatherData: CurrentWeather,
                                completion: @escaping (UIImage) -> Void) {
        guard let iconID = currentWeatherData.iconID else { return }
        let url = NetworkRequest.loadImage(id: iconID).generateURL()
        networkManager.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completion(image)
            case .failure(_):
                return
            }
        }
    }
}
