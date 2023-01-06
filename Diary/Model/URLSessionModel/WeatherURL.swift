//
//  WeatherUrl.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2023/01/03.
//

import Foundation

enum WeatherURL {
    
    case currentWeatherData(latitude: Double, longitude: Double)
    case weatherIcon(icon: String)
    
    var url: URL? {
        switch self {
        case .currentWeatherData(let latitude, let longitude):
            return makeURL(baseURL: URL(string: "https://api.openweathermap.org"),
                           path: ["data", "2.5", "weather"],
                           queryItems: [URLQueryItem(name: "lat", value: String(latitude)),
                                        URLQueryItem(name: "lon", value: String(longitude)),
                                        URLQueryItem(name: "appid", value: Constant.apiKey)
                                       ])
        case .weatherIcon(let icon):
            return makeURL(baseURL: URL(string: "https://openweathermap.org"),
                           path: ["img", "wn", "\(icon)@2x.png"],
                           queryItems: nil)
        }
    }
    
    func makeURL(baseURL: URL?, path: [String]?, queryItems: [URLQueryItem]?) -> URL? {
        guard let baseURL = baseURL?.description else {
            return nil
        }
        
        var urlComponents = URLComponents(string: baseURL)
        
        if let path = path {
            path.forEach { header in
                urlComponents?.path.append(contentsOf: "/\(header)")
            }
        }
        
        if let queryItems = queryItems {
            urlComponents?.queryItems = queryItems
        }
        
        return urlComponents?.url
    }
}

extension WeatherURL {
    
    enum Constant {
        static let apiKey: String = "0270b477f318e3504f336cdc851eac7b"
    }
}
