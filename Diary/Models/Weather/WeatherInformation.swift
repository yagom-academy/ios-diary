//
//  WeatherInformation.swift
//  Diary
//
//  Created by Mangdi, junho lee, on 2023/01/03.
//

import Foundation

struct WeatherInformation: Codable {
    let weather: [Weather]
}

struct Weather: Codable {
    let main, icon: String

    enum CodingKeys: String, CodingKey {
        case main, icon
    }
}
