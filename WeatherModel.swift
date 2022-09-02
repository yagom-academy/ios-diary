//
//  WeatherModel.swift
//  Diary
//
//  Created by 변재은 on 2022/09/01.
//

import Foundation

struct WeatherModel: Decodable {
    let weather: [WeatherData]
}

struct WeatherData: Decodable {
    let main: String
    let icon: String
}
