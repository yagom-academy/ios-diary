//
//  LocationManager.swift
//  Diary
//
//  Created by Mangdi, junho lee, on 2023/01/03.
//

import CoreLocation

final class LocationManager: NSObject {
    typealias Completion = (CLLocation?, Error?) -> Void
    private var locationManager = CLLocationManager()
    private var completion: Completion?
    var isAuthorized: Bool {
        return locationManager.authorizationStatus == .authorizedWhenInUse
    }

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func currentLocation(completion: @escaping Completion) {
        self.completion = completion
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            return
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let completion = completion else { return }
        guard isAuthorized else {
            completion(nil, nil)
            return
        }
        completion(locations.last, nil)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let completion = completion else { return }
        completion(nil, error)
    }
}
