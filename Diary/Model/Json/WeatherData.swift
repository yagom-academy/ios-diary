//
//  WeatherData.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/09/02.
//

struct WeatherData: Decodable {
    let weather: [Weather]
}

struct Weather: Decodable {
    let main, icon: String
}
