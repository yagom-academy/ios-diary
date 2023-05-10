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
    let longtitude: String
    let method: HTTPMethod = .get
    let path = "/data/2.5/weather"
    var headers: [String : String]?
    var queries: [String : String?] {
        [
            "lat": self.latitude,
            "lon": self.longtitude,
            "appid": self.serviceKey
        ]
    }
}
