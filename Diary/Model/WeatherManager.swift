//
//  WeatherManager.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2023/01/03.
//

import CoreLocation
import UIKit

final class WeatherManager: NSObject {
    
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
    
    func fetchWeatherInfo(completion: @escaping (WeatherInfo?) -> Void) {
        guard let url = WeatherURL.currentWeatherData(latitude: currentLocation.latitude,
                                                      longitude: currentLocation.longitude,
                                                      apiKey: Constant.apiKey).url else {
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

extension WeatherManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locationCoordinate: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        currentLocation = (locationCoordinate.latitude, locationCoordinate.longitude)
    }
}

extension WeatherManager {
    
    enum Constant {
        static let apiKey: String = "0270b477f318e3504f336cdc851eac7b"
    }
}
