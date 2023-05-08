//
//  EndPoint.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/05/08.
//

import Foundation

typealias Query = [String: String]

protocol EndpointType {
    var baseURL: String { get }
    var path: String { get }
    func asURLRequest() -> URLRequest?
}

// MARK: - EndPoint
enum EndPoint {
    case weatherInfo(latitude: String, longitude: String)
    case weatherImage(iconCode: String)
    
    private var key: String? {
        switch self {
        case .weatherInfo:
            return "3a1457f28563a335c26ab4b987303134"
        case .weatherImage:
            return nil
        }
    }
}

extension EndPoint: EndpointType {
    var baseURL: String {
        switch self {
        case .weatherInfo:
            return "https://api.openweathermap.org"
        case .weatherImage:
            return "https://openweathermap.org"
        }
    }
    
    var path: String {
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
            return ["lat": latitude, "lon": longitude]
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
        
        var request: URLRequest = URLRequest(url: url)
        
        return request
    }
}
