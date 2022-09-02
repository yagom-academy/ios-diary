//
//  LocationManager.swift
//  Diary
//
//  Created by dhoney96 on 2022/09/02.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    
    var latitude: Double? {
        guard let latitude = locationManager.location?.coordinate.latitude else {
            return nil
        }
        
        return latitude
    }
    
    var longitude: Double? {
        guard let longitude = locationManager.location?.coordinate.longitude else {
            return nil
        }
        
        return longitude
    }
    
    override init() {
        super.init()
        self.setupDefault()
    }
    
    func setupDefault() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
}
