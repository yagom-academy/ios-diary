//
//  WeatherData.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/05/08.
//

struct WeatherData: Codable {
    let weather: [Weather]
}

struct Weather: Codable {
    let type: String
    let iconCode: String
    
    private enum CodingKeys: String, CodingKey {
        case type = "main"
        case iconCode = "icon"
    }
}
