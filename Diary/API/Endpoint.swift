//
//  APIOption.swift
//  Diary
//
//  Created by LIMGAUI on 2022/06/29.
//

import Foundation

enum Endpoint {
  case weatherApi(lat: Double, lon: Double)
  case iconImage(iconID: String)
}

extension Endpoint {
  var url: URL? {
    switch self {
    case .weatherApi(let lat, let lon):
      return .makeWeatherApi("lat=\(lat)&lon=\(lon)&appid=88db245fdcf84f6e66530a76837b25cb")
    case .iconImage(let iconID):
      return .makeIconImage("\(iconID)@2x.png")
    }
  }
}

private extension URL {
  static let baseWeatherURL = "https://api.openweathermap.org/data/2.5/weather?"
  static let baseIconImageURL = "http://openweathermap.org/img/wn/"
  
  static func makeWeatherApi(_ endpoint: String) -> URL? {
    return URL(string: baseWeatherURL + endpoint)
  }
  
  static func makeIconImage(_ endpoint: String) -> URL? {
    return URL(string: baseIconImageURL + endpoint)
  }
}
