//
//  WeatherData.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/05/10.
//

import Foundation

struct WeatherData: Codable {
    let weather: [Weather]
}

struct Weather: Codable {
    let icon: String
}
