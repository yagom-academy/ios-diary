//
//  WeatherRequest.swift
//  Diary
//
//  Created by junho lee on 2023/01/04.
//

import Foundation

enum WeatherRequest {
    case fetchWeatherInformation(latitude: Double, longitude: Double)
    case fetchWeatherIcon(iconID: String)

    private var baseURL: String {
        switch self {
        case .fetchWeatherInformation:
            return "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=e90df98474f5c60414cd6f3955345dd6"
        case .fetchWeatherIcon:
            return "http://openweathermap.org/img/wn/%@@2x.png"
        }
    }

    private var url: URL? {
        switch self {
        case .fetchWeatherInformation(let latitude, let longitude):
            return URL(string: String(format: baseURL, latitude, longitude))
        case .fetchWeatherIcon(let iconID):
            return URL(string: String(format: baseURL, iconID))
        }
    }

    var request: URLRequest? {
        guard let url = url else { return nil }
        return URLRequest(url: url)
    }
}
