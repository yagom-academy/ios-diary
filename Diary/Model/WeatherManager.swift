//
//  WeatherManager.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2023/01/03.
//

import CoreLocation
import UIKit

final class WeatherManager {
    private let locationManager = LocationManager()
    private var location: (latitude: Double, longitude: Double) {
        locationManager.fetchLocation()
    }
    
    func fetchWeatherInfo(completion: @escaping (WeatherInfo?) -> Void) {
        guard let url = WeatherURL.currentWeatherData(latitude: location.latitude,
                                                      longitude: location.longitude).url else {
            return
        }
        
        URLSessionProvider().fetchData(url: url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    guard let decodedWeather = DecodeManager.decodeWeatherData(data) else {
                        completion(nil)
                        return
                    }
                    completion(decodedWeather)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchWeatherIcon(icon: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = WeatherURL.weatherIcon(icon: icon).url else {
            return
        }
        
        URLSessionProvider().fetchData(url: url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

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
