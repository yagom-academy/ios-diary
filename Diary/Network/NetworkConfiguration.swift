//
//  NetworkConfiguration.swift
//  Diary
//
//  Created by Maxhyunm, Hamg on 2023/09/13.
//

import Foundation

enum NetworkConfiguration {
    case weatherAPI(latitude: Double, longitude: Double)
    case weatherIcon(id: String)
    
    var url: String? {
        switch self {
        case .weatherAPI(let latitude, let longitude):
            guard let apiKey = NetworkConfiguration.apiKey else { return nil }
            return "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        case .weatherIcon(let id):
            return  "https://openweathermap.org/img/wn/\(id).png"
        }
    }
    
    static var apiKey: String? {
        guard let path = Bundle.main.url(forResource: "Key", withExtension: "plist"),
              let plist = NSDictionary(contentsOf: path),
                let key = plist.value(forKey: "WeatherAPIKey") else {
            return nil
        }
        return "\(key)"
    }
}
