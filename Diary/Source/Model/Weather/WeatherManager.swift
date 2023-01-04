//
//  WeatherManager.swift
//  Diary
//  Created by inho, dragon on 2023/01/04.
//

import Foundation

struct WeatherManager {
    let networkManager = NetworkManager()
    
    func fetchWeather(latitude: String, longitude: String) {
        let url = "\(URL.weatherBaseURL)\(URL.apiKey)&lat=\(latitude)&lon=\(longitude)"
        
        networkManager.performRequest(urlString: url)
    }
    
    func fetchWeatherIcon(of icon: String) {
        let url = "\(URL.iconBaseURL)\(icon).png"
        
        networkManager.performRequest(urlString: url)
    }
}

private enum URL {
    static let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    static let iconBaseURL = "http://openweathermap.org/img/wn/"
    static let apiKey = "&appid=5f59dfe269b02950236b1f89e72dc05f"
}
