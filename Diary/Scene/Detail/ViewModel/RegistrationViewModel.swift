//
//  RegistrationViewModel.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/22.
//

import Foundation
import CoreLocation

final class RegistrationViewModel: NSObject {
    private let locationManager = CLLocationManager()
    private(set) var createdAt = Date().timeIntervalSince1970
    private let diaryId = UUID().uuidString
    private var coordinate: CLLocationCoordinate2D?
    private var icon: String?
    private let useCase = WeatherUseCase()
    private var currentText: String?
    let error: ColdObservable<DiaryError> = .init()
    let isLocationDenied: ColdObservable<Bool> = .init()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
}

extension RegistrationViewModel {
    
    // MARK: Input
    
    func viewWillDisappear() {
        saveDiary()
        locationManager.stopUpdatingLocation()
    }
    
    func didEnterBackground() {
        saveDiary()
    }
    
    func keyboardWillHide() {
        saveDiary()
    }
    
    func textViewDidChange(text: String) {
        currentText = text
    }
    
    func didUpdateLocations(by coordinate: CLLocationCoordinate2D) {
        setUpLocation(by: coordinate)
    }
    
    // MARK: Output
    
    private func saveDiary() {
        guard let content = currentText,
                content.isEmpty == false
        else {
            return
        }
        
        var splitedText = content.components(separatedBy: "\n")
        let title = splitedText.removeFirst()
        let body = splitedText.joined(separator: "\n")

        let diary = Diary(
            title: title,
            createdAt: createdAt,
            body: body,
            id: diaryId,
            icon: icon ?? ""
        )
        
        do {
            try PersistenceManager.shared.createData(by: diary)
        } catch {
            self.error.onNext(value: .saveFail)
        }
    }
    
    private func setUpLocation(by coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        requestWeather()
    }
    
    private func requestWeather() {
        useCase.requestWeather(
            latitude: coordinate?.latitude,
            longitude: coordinate?.longitude
        ) { (result: Result<String, NetworkError>) in
            switch result {
            case .success(let icon):
                self.icon = icon
            case .failure:
                self.icon = nil
            }
        }
    }
}

extension RegistrationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            didUpdateLocations(by: coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .restricted, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            self.isLocationDenied.onNext(value: true)
        @unknown default:
            return
        }
    }
}
