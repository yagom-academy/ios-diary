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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        locationCompletion?(location) // 마지막으로 받은 위치 데이터 전달
        locationManager.stopUpdatingLocation() // 위치 업데이트 중지
        locationCompletion = nil // 완료 핸들러 제거
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
