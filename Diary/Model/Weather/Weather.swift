//
//  Wheather.swift
//  Diary
//
//  Created by 백곰,주디 on 2022/08/31.
//

struct WeatherInfo: Decodable {
    let main: String
    let icon: String
}

struct Weather: Decodable {
    let weather: [WeatherInfo]
}
