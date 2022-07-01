//
//  WeatherRepository.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/29.
//

import Foundation

final class WeatherService {
  private let networking: Networking

  init(networking: Networking) {
    self.networking = networking
  }

  func fetchWeather(lat: Double, lon: Double, completion: @escaping (Weather) -> Void) {
    let endpoint = APIEndpoint.weatherEndpoint(lat: lat, lon: lon)
    self.networking.request(endpoint: endpoint) { result in
      switch result {
      case .success(let data):
        guard let weatherData = Parser.decode(WeatherResponse.self, data: data) else { return }
        guard let weather = weatherData.weather.first else { return }
        completion(weather)

      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}
