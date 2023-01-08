//
//  WeatherAPI.swift
//  Diary
//  Created by inho, dragon on 2023/01/04.
//

import Foundation

struct CurrentWeatherData: Decodable {
    let weather: [Weather]
}
