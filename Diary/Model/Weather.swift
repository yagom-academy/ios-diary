//
//  Weather.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/23.
//

import Foundation

struct Weather: Decodable {
    let weather: [WeatherElement]
}

struct WeatherElement: Decodable {
    let id: Int
    let icon: String
}
