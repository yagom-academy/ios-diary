//
//  Diary - LocationDataManager.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import CoreLocation

class LocationDataManager: NSObject {
    static let shared = LocationDataManager()
    private var locationManager = CLLocationManager()
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    private override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func fetchLocation() -> (latitude: CLLocationDegrees, longitude: CLLocationDegrees)? {
        guard let latitude,
              let longitude else { return nil }
        
        return (latitude: latitude, longitude: longitude)
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationDataManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            manager.startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            manager.requestWhenInUseAuthorization()
        case .denied:
            print("GPS 권한 요청 거부됨")
            manager.requestWhenInUseAuthorization()
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location update errors
        print("Location update failed with error: \(error.localizedDescription)")
    }
}
