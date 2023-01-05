//
//  APIManager.swift
//  Diary
//
//  Created by Victor on 2023/01/04.
//

import Foundation

enum APIManager {
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    
    case currentWeather(lat: String, lon: String)
    case weatherImage(iconID: String)
    
    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = APIManager.scheme
        urlComponents.host = APIManager.host
        switch self {
        case .currentWeather(lat: let lat, lon: let lon):
            urlComponents.path = "/data/2.5/weather"
            urlComponents.queryItems = [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "appid", value: "6ada3498ba6d05dc92d1d9dd67567986")
            ]
        case .weatherImage(iconID: let iconID):
            urlComponents.host = "openweathermap.org"
            urlComponents.path = "/img/wn/\(iconID).png"
        }
        
        return urlComponents
    }
}
