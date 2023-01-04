//
//  Weather.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2023/01/03.
//

import Foundation

struct WeatherResponseDTO: Decodable {
    let weather: [Weather]
}

extension WeatherResponseDTO {
    func toDomain() -> Weather {
        return weather[0]
    }
}

struct Weather: Hashable, Decodable {
    let main: String
    let icon: String

    init(main: String, icon: String) {
        self.main = main
        self.icon = icon
    }
}
