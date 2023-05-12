//  Diary - WeatherJsonData.swift
//  created by vetto on 2023/05/09

import Foundation

// MARK: - WeatherJSONData
struct WeatherJSONData: Decodable {
    let weather: [Weather]

    private enum CodingKeys: String, CodingKey {
        case weather
    }
    
    var weatherMain: String {
        guard let main = self.weather.first?.main else { return "" }
        
        return main
    }
    
    var weatherIcon: String {
        guard let icon = self.weather.first?.icon else { return "" }
        
        return icon
    }
}

// MARK: - Weather
struct Weather: Decodable {
    var main, icon: String
}
