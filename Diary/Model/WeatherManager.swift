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
    
    func fetchWeatherInfo() -> Weather? {
        var weather: Weather?
        
        guard let url = WeatherURL.currentWeatherData(latitude: currentLocation.latitude,
                                                      longitude: currentLocation.longitude,
                                                      apiKey: Constant.apiKey).url else {
            return nil
        }
        
        URLSessionProvider().fetchData(url: url) { result in
            switch result {
            case .success(let data):
                guard let decodedWeather = DecodeManager.decodeWeatherData(data) else {
                    return
                }
                weather = decodedWeather
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return weather
    }
    
    func fetchWeatherIcon(icon: String) -> UIImage? {
        var image: UIImage?
        
        guard let url = WeatherURL.weatherIcon(icon: icon).url else {
            return nil
        }
        
        URLSessionProvider().fetchData(url: url) { result in
            switch result {
            case .success(let data):
                image = UIImage(data: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return image
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
