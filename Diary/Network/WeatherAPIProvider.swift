//
//  WeatherAPIProvider.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2023/01/10.
//

import Foundation
import CoreLocation

final class WeatherAPIProvider {
    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("plist를 찾을 수 없습니다.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "Open Weather API KEY") as? String else {
            fatalError("Open Weather API KEY를 찾을 수 없습니다.")
        }

        return value
    }

    private var coordinate: CLLocationCoordinate2D {
        guard let coordinate = CLLocationManager().location?.coordinate else {
            fatalError("위치를 찾을 수 없습니다.")
        }

        return coordinate
    }

    var weatherDataURL: URL? {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        let latitude = URLQueryItem(name: "lat", value: "\(self.coordinate.latitude)")
        let longitude = URLQueryItem(name: "lon", value: "\(self.coordinate.longitude)")
        let appID = URLQueryItem(name: "appid", value: "\(self.apiKey)")
        components?.queryItems = [latitude, longitude, appID]

        return components?.url
    }

    func weatherIconURL(icon: String) -> URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}
