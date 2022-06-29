//
//  APIEndpoint.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/29.
//

import Foundation

struct APIEndpoint {
  static func fetchWeather(lat: Double, lon: Double) -> Endpoint {
    return Endpoint(
      baseURL: "https://api.openweathermap.org",
      path: "data/2.5/weather",
      queries: [
        "lat": "\(lat)",
        "lon": "\(lon)",
        "appid": "c2da2eb2d3d8092983a8ad336224a808"
      ]
    )
  }

  static func fetchWeatherIcon(iconID: String) -> Endpoint {
    return Endpoint(
      baseURL: "https://openweathermap.org",
      path: "img/wn/\(iconID)@2x.png"
    )
  }
}
