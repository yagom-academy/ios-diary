//
//  URLComponents.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/14.
//

import Foundation

enum HostName {
    case localWeather
    case weatherIcon
    
    var address: String {
        switch self {
        case .localWeather:
            return "api.openweathermap.org"
        case .weatherIcon:
            return "openweathermap.org"
        }
    }
}

enum Path {
    case localWeather
    case weatherIcon(id: String)
    
    var description: String {
        switch self {
        case .localWeather:
            return "/data/2.5/weather"
        case .weatherIcon(let id):
            return "/img/wn/\(id).png"
        }
    }
}

enum Query {
    case localWeather(latitude: Double, longitude: Double)
    
    var parameters: [String: String] {
        switch self {
        case .localWeather(let latitude, let longitude):
            return ["lat": "\(latitude)", "lon": "\(longitude)", "appid": APIKey.weather]
        }
    }
}

enum APIKey {
    static var weather: String {
        guard let file = Bundle.main.path(forResource: "WeatherInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY"] as? String else {
            fatalError("⛔️ API KEY를 가져오는데 실패하였습니다.")
        }
        
        return key
    }
}
