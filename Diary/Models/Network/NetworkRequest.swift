//
//  NetworkRequest.swift
//  Diary
//
//  Created by Kyo, Baem on 2023/01/03.
//

import Foundation

enum NetworkRequest {
    case fetchData(lat: String, lon: String)
    case loadImage(id: String)
    
    private var baseURL: String {
        switch self {
        case .fetchData(lat: _, lon: _):
            return "https://api.openweathermap.org"
        case .loadImage(id: _):
            return "https://openweathermap.org"
        }
    }
    
    private var path: String {
        switch self {
        case .fetchData(lat: _, lon: _):
            return "/data/2.5/weather"
        case .loadImage(let id):
            return "/img/wn/\(id).png"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchData(let lat, let lon):
            return [
                URLQueryItem(name: "lat", value: lat),
                URLQueryItem(name: "lon", value: lon),
                URLQueryItem(name: "appid", value: "ea1b2bb64426b9b5d864611d85d080f9")
            ]
        case .loadImage(id: _):
            return []
        }
    }
    
    func generateURL() -> URL? {
        var urlComponent = URLComponents(string: baseURL)
        urlComponent?.path = path
        urlComponent?.queryItems = queryItems
        
        return urlComponent?.url
    }
}
