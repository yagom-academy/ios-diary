//
//  Weather.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2023/01/03.
//

import Foundation

struct Weather: Decodable {
    
    struct WeatherInfo: Decodable {
        let main: String
        let icon: String
    }
    
    let weather: [WeatherInfo]
}
