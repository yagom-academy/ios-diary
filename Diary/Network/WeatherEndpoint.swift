//
//  WeatherEndpoint.swift
//  Diary
//
//  Created by 리지, Goat on 2023/05/05.
//

import Foundation

enum WeatherEndpoint {
    case weatherInformation(latitude: String, longitude: String)
    case weatherIcon(icon: String)
}

extension WeatherEndpoint {
    var baseURL: String {
        switch self {
        case .weatherInformation:
            return "https://api.openweathermap.org"
        case .weatherIcon:
            return "https://openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .weatherInformation:
            return "/data/2.5/weather"
        case .weatherIcon(let icon):
            return "/img/wn/\(icon)@2x.png"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .weatherInformation(let latitude, let longitude):
            return [
                URLQueryItem(name: "lat", value: latitude),
                URLQueryItem(name: "lon", value: longitude),
                URLQueryItem(name: "appid", value: key)
            ]
        case .weatherIcon:
            return [
                URLQueryItem(name: "", value: nil)
            ]
        }
    }
    
    var key: String {
        return "3d36b14687e157861edfe9ef31f3b6fd"
    }
    
    func createURL() -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return nil }
        
        return url
    }
    
    func createURLRequestForGET() -> URLRequest? {
        guard let url = createURL() else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.description
        
        switch self {
        case .weatherInformation:
            return urlRequest
        case .weatherIcon:
            return urlRequest
        }
    }
}
