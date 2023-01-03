//
//  WeatherManager.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2023/01/03.
//

import Foundation
import CoreLocation

final class WeatherManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        return locationManager
    }()
    
    private var currentLocation: (latitude: Double, longitude: Double) = (0, 0)
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationCoordinate: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        currentLocation = (locationCoordinate.latitude, locationCoordinate.longitude)
    }
}
