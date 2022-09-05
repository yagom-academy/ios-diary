//
//  APIRequest.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/29.
//

import Foundation

enum HTTPMethod {
    case get
    case post
    case delete
    case patch
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        }
    }
}

enum URLHost {
    case openWeather
    case weatherIcon
    case sample
    
    var url: String {
        switch self {
        case .openWeather:
            return "https://api.openweathermap.org"
        case .sample:
            return "sample"
        case .weatherIcon:
            return "https://openweathermap.org"
        }
    }
}

enum URLAdditionalPath {
    case weather
    case weatherIcon(_ icon: String)
    
    var value: String {
        switch self {
        case .weather:
            return "/data/2.5/weather"
        case .weatherIcon(let iconID):
            return "/img/wn/\(iconID)@2x.png"
        }
    }
}

protocol APIRequest {
    var method: HTTPMethod { get }
    var baseURL: String { get }
    var headers: [String: String]? { get }
    var query: [URLQueryItem]? { get }
    var body: Data? { get }
    var path: URLAdditionalPath { get }
}

extension APIRequest {
    var url: URL? {
        var component = URLComponents(string: "\(self.baseURL)" + "\(self.path.value)")
        component?.queryItems = query
        
        return component?.url
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.name
        request.httpBody = self.body
        self.headers?.forEach { request.addValue($0, forHTTPHeaderField: $1) }
        
        return request
    }
}
