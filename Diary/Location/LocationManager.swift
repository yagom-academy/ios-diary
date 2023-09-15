//
//  LocationManager.swift
//  Diary
//
//  Created by 김민성 on 2023/09/14.
//

import CoreLocation
import Foundation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var locationCompletion: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func fetchSingleLocation(completion: @escaping (CLLocation) -> Void) {
        self.locationCompletion = completion
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else {
            return
        }
        locationCompletion?(location)
        locationManager.stopUpdatingLocation()
        locationCompletion = nil
    }
}
