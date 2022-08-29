//
//  Weather.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/29.
//

import Foundation

struct WeatherModel: Codable {
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
