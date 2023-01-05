//
//  WeatherData.swift
//  Diary
//
//  Created by Kyo, Baem on 2023/01/03.
//

import Foundation

struct WeatherAPIData: Decodable {
    let weather: [Weather]
}

struct Weather: Decodable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
