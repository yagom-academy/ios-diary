//
//  Requesting.swift
//  Diary
//
//  Copyright (c) 2023 Minii All rights reserved.
        

import Foundation
import CoreLocation

protocol Requesting {
    var baseURL: String { get }
    var method: String { get }
    var path: String { get }
    var query: [URLQueryItem] { get }
}

extension Requesting {
    static var key: String {
        return "eff332b31ce61b1c3ce23c3c9f2bd3ed"
    }
    
    func convertURL() -> URL? {
        guard var component = URLComponents(string: baseURL) else {
            return nil
        }
        
        component.path = path
        component.queryItems = query
        
        return component.url
    }
}

struct SearchWeatherAPI: Requesting {
    let baseURL: String = "https://api.openweathermap.org"
    let method: String = "get"
    let path: String = "/data/2.5/weather"
    let query: [URLQueryItem]
    
    init(location: CLLocationCoordinate2D) {
        let coordinatorQuery: [String: String] = [
            "lat": location.latitude.description,
            "lon": location.longitude.description,
            "appid": Self.key
        ]
        
        query = coordinatorQuery.queryValues
    }
}

extension Dictionary where Key == String, Value == String {
    var queryValues: [URLQueryItem] {
        return self.map { .init(name: $0.key, value: $0.value) }
    }
}
