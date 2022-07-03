//
//  RegisterViewController.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/17.
//

import UIKit
import CoreLocation

final class RegisterViewController: UIViewController, ErrorAlertProtocol {
    private let locationManager = CLLocationManager()
    private var diaryModel: DiaryModel?
    private lazy var detailView = DetailView(frame: view.frame)
    private let diaryViewModel = DiaryViewModel()
    private var icon: String?
}

// MARK: - View Life Cycle Method

extension RegisterViewController {
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        registerDidEnterBackgroundNotification()
        registerKeyboardNotifications()
        registerCoreLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailView.titleField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sendDiaryViewModel()
    }
}

// MARK: - Method

extension RegisterViewController {
    
    private func registerDidEnterBackgroundNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    private func sendDiaryViewModel() {
        do {
            try diaryViewModel.checkDiaryData(
                title: detailView.titleField.text,
                body: detailView.descriptionView.text,
                icon: icon
            )
        } catch {
            showAlert(alertMessage: error.localizedDescription)
        }
    }
}

// MARK: - Action Method

extension RegisterViewController {
    
    @objc private func didEnterBackground() {
        sendDiaryViewModel()
    }
}

// MARK: - Keyboard Method

extension RegisterViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue else { return }
        detailView.mainScrollView.contentInset.bottom = keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        detailView.mainScrollView.contentInset.bottom = .zero
        sendDiaryViewModel()
    }
}

// MARK: - Core Location Method

extension RegisterViewController: CLLocationManagerDelegate {
    
    private func registerCoreLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = Double(location.coordinate.latitude)
            let longitude = Double(location.coordinate.longitude)
            let diaryRegisterUseCase = DiaryRegisterUseCase(
                network: Network(),
                jsonDecoder: JSONDecoder(),
                coordinateManager: CoordinateManager(
                    latitude: latitude,
                    longitude: longitude
                )
            )
            diaryRegisterUseCase.requestWeatherInformation { [weak self] data in
                guard let icon = data.weather.first?.icon else { return }
                self?.icon = icon
            } errorHandler: { error in
                print(error)
            }
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Error: \(error.localizedDescription)")
    }
}
