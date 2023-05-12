//
//  OpenWeatherAPI.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import Foundation

enum OpenWeatherAPI: APIInfo {
    case currentData(latitude: Double, longitude: Double)
    case icon(code: String)
    
    var baseURL: String {
        switch self {
        case .currentData:
            return "https://api.openweathermap.org"
        case .icon:
            return "https://openweathermap.org"
        }
    }
    
    var key: String {
        return "6d61b293731a228c5465458ba06032b5"
    }
    
    var path: String {
        switch self {
        case .currentData:
            return "/data/2.5/weather"
        case .icon(let code):
            return "/img/wn/\(code)@2x.png"
        }
    }
    
    var queries: [URLQueryItem] {
        switch self {
        case .currentData(let latitude, let longitude):
            let queryItems = [
                URLQueryItem(name: "lat", value: String(latitude)),
                URLQueryItem(name: "lon", value: String(longitude)),
                URLQueryItem(name: "appid", value: key)
            ]
            
            return queryItems
        default:
            return []
        }
    }
    
    var headers: [String: String] {
        return [:]
    }
}
