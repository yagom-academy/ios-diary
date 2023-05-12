//
//  LocationDataManager.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/11.
//

import CoreLocation

protocol LocationDataManagerProtocol: AnyObject {
    func presentSystemSettingAlert()
    func setDiaryWeatherInformation(with currentCoordinate: CLLocationCoordinate2D)
}

final class LocationDataManager: NSObject {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationDataManagerProtocol?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
}

extension LocationDataManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentCoordinate = locations.last?.coordinate {
            delegate?.setDiaryWeatherInformation(with: currentCoordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .restricted, .denied:
            delegate?.presentSystemSettingAlert()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}
