//
//  LocationManager.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/05/11.
//

import CoreLocation

final class LocationManager: NSObject {
    private let locationManager = CLLocationManager()

    func activateLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Core location delegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate2D = locations.last?.coordinate {
            let coordinate = Coordinate(latitude: String(coordinate2D.latitude),
                                        longitude: String(coordinate2D.longitude))
            NotificationCenter.default.post(name: .didGetLocationNotification, object: coordinate)
        }
    }
}
