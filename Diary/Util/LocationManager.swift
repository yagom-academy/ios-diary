//
//  LocationManager.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/07/03.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
  private let clLocationManager: CLLocationManager
  private let weatherService: WeatherService
  private var coordinate: CLLocationCoordinate2D?

  override init() {
    self.weatherService = WeatherService(networking: .init(session: .shared))
    self.clLocationManager = CLLocationManager()
    super.init()
    self.clLocationManager.requestWhenInUseAuthorization()
    self.clLocationManager.startUpdatingLocation()
    self.clLocationManager.delegate = self
  }

  func fetchWeather(completion: @escaping (Weather) -> Void) {
    guard let coordinate = coordinate else { return }
    self.weatherService.fetchWeather(lat: coordinate.latitude, lon: coordinate.longitude) { weather in
      completion(weather)
    }
  }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let coordinate = locations.last?.coordinate else { return }
    self.coordinate = coordinate
    self.clLocationManager.stopUpdatingLocation()
  }
}
