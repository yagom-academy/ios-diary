//
//  OpenWeatherEndpoint.swift
//  Diary
//
//  Created by kimseongjun on 2023/05/09.
//

import Foundation


struct OpenWeatherEndpoint: EndpointMakeable {
    var baseURL: String = "https://api.openweathermap.org"
    var path: String = "/data/2.5/weather"
    var method: String = HTTPMethod.get
    var queryItems: [URLQueryItem] = [URLQueryItem(name: "appid", value: "999fe28a79a2691ec4db3d709dca4e4d")]
    var header: [String : String]?
    
    mutating func insert(lat: String, lon: String) {
        queryItems.append(URLQueryItem(name: "lat", value: lat))
        queryItems.append(URLQueryItem(name: "lon", value: lon))
    }
}
