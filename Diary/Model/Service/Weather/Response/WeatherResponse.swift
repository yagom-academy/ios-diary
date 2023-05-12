//
//  WeatherResponse.swift
//  Diary
//
//  Created by Andrew, brody on 2023/05/10.
//

import Foundation

struct WeatherResponse: Decodable {
    let weather: [Weather]
}

struct Weather: Decodable {
    let id: Int
    let weatherCondition, description, icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, description, icon
        case weatherCondition  = "main"
    }
}

extension WeatherResponse {
    func convertToWeatherItems() -> WeatherInformation {
        return WeatherInformation(
            main: self.weather[0].weatherCondition,
            iconCode: self.weather[0].icon
        )
    }
}
