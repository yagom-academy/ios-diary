//
//  LocationManager.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/27.
//

import CoreLocation
import UIKit

final class LocationManager {
    static let coreLocation = CLLocationManager()
    
    static func agree(viewController: CLLocationManagerDelegate) {
        coreLocation.requestAlwaysAuthorization()
        coreLocation.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            coreLocation.delegate = viewController
            coreLocation.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            coreLocation.startUpdatingLocation()
        }
    }
}
