//
//  WeatherManager.swift
//  Diary
//  Created by inho, dragon on 2023/01/04.
//

import UIKit
import CoreLocation

struct WeatherManager {
    let networkManager = NetworkManager()
    
    func fetchWeather(latitude: CLLocationDegrees,
                      longitude: CLLocationDegrees,
                      completion: @escaping (Weather) -> Void) {
        let url = "\(URL.weatherBaseURL)\(URL.apiKey)&lat=\(latitude)&lon=\(longitude)"
        
        networkManager.performRequest(urlString: url) { data in
            if let weatherAPI = JSONDecoder.decodeData(data: data, to: WeatherAPI.self),
               let weather = weatherAPI.weather.first {
                completion(weather)
            }
        }
    }
    
    func fetchWeatherIcon(of icon: String,
                          completion: @escaping (UIImage) -> Void) {
        guard !icon.isEmpty else { return }
        
        let url = "\(URL.iconBaseURL)\(icon).png"
        
        networkManager.performRequest(urlString: url) { data in
            if let image = UIImage(data: data) {
                completion(image)
            }
        }
    }
}

private enum URL {
    static let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    static let iconBaseURL = "https://openweathermap.org/img/wn/"
    static let apiKey = "&appid=5f59dfe269b02950236b1f89e72dc05f"
}
