//  Diary - WeatherJsonData.swift
//  created by vetto on 2023/05/09

import Foundation

// MARK: - WeatherJSONData
struct WeatherJSONData: Decodable {
    let weather: [Weather]

    private enum CodingKeys: String, CodingKey {
        case weather
    }
    // MARK: - Weather
    struct Weather: Decodable {
        let main, icon: String
    }
}
