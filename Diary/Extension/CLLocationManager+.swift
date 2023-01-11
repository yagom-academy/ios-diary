//
//  LocationManager.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2023/01/10.
//

import CoreLocation

extension CLLocationManager {
    var coordinate: CLLocationCoordinate2D? {
        guard let coordinate = self.location?.coordinate else {
            return nil
        }

        return coordinate
    }

    var isAuthorizationAllow: Bool {
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
}
