//
//  WeatherAPIProvider.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2023/01/10.
//

import Foundation
import CoreLocation

enum WeatherAPIProvider: APIProvidable {
    case weatherData
    case weatherIcon(icon: String)
    private var apiKey: String? {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            assertionFailure("plist를 찾을 수 없습니다.")
            return nil
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "Open Weather API KEY") as? String else {
            assertionFailure("Open Weather API KEY를 찾을 수 없습니다.")
            return nil
        }

        return value
    }

    var url: URL? {
        switch self {
        case .weatherData:
            var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
            guard let coordinate = CLLocationManager().coordinate,
                  let apiKey = apiKey else {
                return nil
            }
            let latitude = URLQueryItem(name: "lat", value: "\(coordinate.latitude)")
            let longitude = URLQueryItem(name: "lon", value: "\(coordinate.longitude)")
            let appID = URLQueryItem(name: "appid", value: "\(apiKey)")
            components?.queryItems = [latitude, longitude, appID]

            return components?.url
        case .weatherIcon(let icon):
            return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        }
    }
}
