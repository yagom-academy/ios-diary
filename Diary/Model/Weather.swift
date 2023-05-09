//
//  Weather.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import Foundation

struct CurrentWeather: Codable {
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}
