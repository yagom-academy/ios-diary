//
//  LocationManager.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2023/01/06.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    private let manager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        return locationManager
    }()
    
    private var location: (latitude: Double, longitude: Double) = (0, 0)
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func fetchLocation() -> (latitude: Double, longitude: Double) {
        manager.requestLocation()
        return location
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationCoordinate: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }

        location = (locationCoordinate.latitude, locationCoordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
