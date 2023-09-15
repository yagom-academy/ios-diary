//
//  Weather.swift
//  Diary
//
//  Created by 김민성 on 2023/09/14.
//

struct WeatherData: Decodable {
    let weather: [Weather]
}

struct Weather: Decodable {
    let icon: String
}
