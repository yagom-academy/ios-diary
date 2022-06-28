//
//  EndpointStorage.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/28.
//

import Foundation

enum EndpointStorage {
    private enum Constants {
        static let weatherInfoURL = "https://api.openweathermap.org/"
        static let weatherInfoPath = "data/2.5/weather?"
        
        static let weatherIconURL = "https://openweathermap.org/"
        static let weatherIconPath = "img/wn/"
        
        static let appkey = "5d541eac3b64ce81f672025857e60683"
    }
    
    case weatherInfo(_ latitude: Double, _ longitude: Double)
    case weatherIcon(_ icon: String)
    
    var endPoint: Requestable {
        switch self {
        case .weatherInfo(let latitude, let longitude):
            return Endpoint(
                baseURL: Constants.weatherInfoURL,
                path: Constants.weatherInfoPath,
                queryParameters: WeatherRequest(
                    latitude: latitude,
                    longitude: longitude,
                    appId: Constants.appkey
                )
            )
        case .weatherIcon(let icon):
            return Endpoint(
                baseURL: Constants.weatherIconURL,
                path: "\(Constants.weatherIconPath)\(icon)@2x.png"
            )
        }
    }
}
