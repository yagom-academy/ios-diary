//
//  WeatherInfo.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/27.
//

import Foundation

struct WeatherData: Decodable {
    let weather: [WeatherDetail]
}

struct WeatherDetail: Decodable {
    let main: String
    let icon: String
}
