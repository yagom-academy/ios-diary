//
//  APIRequest.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/09/02.
//

import Foundation

enum URLHost {
    case openWeather
    
    var url: String {
        switch self {
        case .openWeather:
            return "https://api.openweathermap.org"
        }
    }
}

enum URLAdditionalPath {
    case data
    
    var value: String {
        switch self {
        case .data:
            return "/data/2.5/weather"
        }
    }
}

enum URLQuery {
    case latitude
    case longitude
    case apiKey
    case mode
    case units
    case language
    
    var text: String {
        switch self {
        case .latitude:
            return "lat"
        case .longitude:
            return "lon"
        case .apiKey:
            return "appid"
        case .mode:
            return "mode"
        case .units:
            return "units"
        case .language:
            return "lang"
        }
    }
}

protocol APIRequest {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var headers: [String: String]? { get }
    var query: [String: String]? { get }
    var path: String { get }
}

extension APIRequest {
    var url: URL? {
        var urlComponents = URLComponents(string: baseURL + path)
        
        if let query = query {
        urlComponents?.queryItems = query.map {
            URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        return urlComponents?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.name
        headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
}
