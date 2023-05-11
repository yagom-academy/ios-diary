//
//  WeatherData.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/05/10.
//

struct WeatherData: Decodable {
    let weather: [Weather]
}

struct Weather: Decodable {
    let icon: String
}
