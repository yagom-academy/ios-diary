//
//  LocationDataManager.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/11.
//

import CoreLocation

protocol Presentable: AnyObject {
    func presentSystemSettingAlert()
}

final class LocationDataManager: NSObject {
    private let locationManager = CLLocationManager()
    weak var delegate: Presentable?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
}

extension LocationDataManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
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
