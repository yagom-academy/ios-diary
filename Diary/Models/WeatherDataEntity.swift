//
//  WeatherDataEntity.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/27.
//

struct Weather: Decodable {
    let main: String
    let icon: String
}

struct WeatherDataEntity: Decodable {
    let weather: [Weather]
}
