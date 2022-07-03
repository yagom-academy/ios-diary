//
//  OpenWeatherAPI.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/07/01.
//

import Foundation

enum OpenWeatherAPI {
    private static let hostURL = "https://api.openweathermap.org/data/2.5/weather?"
    private static let iconURL = "https://openweathermap.org/img/wn/"
    private static let secrateKey = "ce551c3a0cac40d061a38d6ffacc4e02"
    
    case weatherInformation(latitude: Double, longitude: Double)
    case weatherIconImage(icon: String)
    
    private var urlString: String {
        switch self {
        case .weatherInformation(let latitude, let longitude):
            return Self.hostURL + "lat=\(latitude)&lon=\(longitude)&appid=" + Self.secrateKey
        case .weatherIconImage(let icon):
            return Self.iconURL + "\(icon)@2x.png"
        }
    }
    
    var url: URL? {
        let urlComponents = URLComponents(string: self.urlString)
        return urlComponents?.url
    }
}
