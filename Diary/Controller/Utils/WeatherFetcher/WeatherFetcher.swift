//
//  WeatherFetcher.swift
//  Diary
//
//  Created by 김민성 on 2023/09/15.
//

import Foundation
import UIKit

struct WeatherFetcher {
    let locationManager: LocationManager
    
    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
    }
    
    func fetch(_ completion: @escaping (Data?) -> Void) {
        locationManager.fetchSingleLocation { location in
            Task {
                do {
                    let weather = try await NetworkManager.fetchCurrentWeather(coordinate: location.coordinate)
                    
                    let icon = try await NetworkManager.fetchWeatherIcon(icon: weather?.icon)
                    completion(icon)
                } catch {
                    completion(nil)
                }
            }
        }
    }
}
