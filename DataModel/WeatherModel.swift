//
//  WeatherModel.swift
//  Diary
//
//  Created by 재재, 그루트 2022/09/01.
//

import Foundation

struct WeatherModel: Decodable {
    let weather: [WeatherData]
}

struct WeatherData: Decodable {
    let main: String
    let icon: String
}
