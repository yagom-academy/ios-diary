//
//  EndPoint.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/05/08.
//

import Foundation

typealias Query = [String: String]

// MARK: - EndPoint
enum EndPoint {
    case weatherInfo(latitude: String, longitude: String)
    case weatherImage(iconCode: String)
}

extension EndPoint {
    private var baseURL: String {
        switch self {
        case .weatherInfo:
            return "https://api.openweathermap.org"
        case .weatherImage:
            return "https://openweathermap.org"
        }
    }
    
    private var path: String {
        switch self {
        case .weatherInfo:
            return "/data/2.5/weather"
        case .weatherImage(let iconCode):
            return "/img/wn/\(iconCode)@2x.png"
        }
    }
    
    private var queries: Query? {
        switch self {
        case .weatherInfo(let latitude, let longitude):
            let key = "3a1457f28563a335c26ab4b987303134"
            
            return ["lat": latitude, "lon": longitude, "appid": key]
        case .weatherImage:
            return nil
        }
    }
    
    private func createURL() -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        
        urlComponents?.path = path
        
        if let queries {
            var queryItems: [URLQueryItem] = []
            
            for (name, value) in queries {
                queryItems.append(URLQueryItem(name: name, value: value))
            }
            
            urlComponents?.queryItems = queryItems
        }
        
        return urlComponents?.url
    }
    
    func asURLRequest() -> URLRequest? {
        guard let url = createURL() else { return nil }
        
        let request: URLRequest = URLRequest(url: url)
        
        return request
    }
}
