//
//  WeatherModel.swift
//  Diary
//
//  Created by unchain, 웡빙 on 2022/08/31.
//

import Foundation

struct WeatherModel: Codable {
    let weather: [Weather]
    let sys: Sys
    let name: String
}

struct Weather: Codable {
    let main: String
    let icon: String
}

struct Sys: Codable {
    let country: String
}
