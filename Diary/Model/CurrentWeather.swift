//
//  CurrentWeather.swift
//  Diary
//
//  Created by dhoney96 on 2022/08/29.
//

import Foundation

struct CurrentWeather: Decodable {
    let weather: [Weather]
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let icon: String
    
    var iconURL: String {
        return API.baseIconURL + icon + API.imageScale
    }
}
