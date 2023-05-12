//
//  WeatherInformationEndpoint.swift
//  Diary
//
//  Created by Andrew on 2023/05/10.
//

import Foundation

struct WeatherInformationEndpoint: WeatherAPIEndpoint {
    typealias APIResponse = WeatherResponse
    
    let latitude: String
    let longitude: String
    let method: HTTPMethod = .get
    let path = "/data/2.5/weather"
    var headers: [String: String]?
    var queries: [String: String?] {
        [
            "lat": self.latitude,
            "lon": self.longitude,
            "appid": self.serviceKey
        ]
    }
}
