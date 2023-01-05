//
//  Weather.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/01/04.
//

struct WeatherModel: Decodable {
    let weather: [Weather]
}

struct Weather: Decodable {
    let main, icon: String
}
