//
//  DailyWeather.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/09.
//

import Foundation

struct Weather: Decodable {
    let weather: [WeatherInfo]
    
    struct WeatherInfo: Decodable {
        let icon: String
    }
}
