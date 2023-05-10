//
//  DailyWeather.swift
//  Diary
//
//  Created by rilla, songjun on 2023/05/09.
//

import Foundation

struct DailyWeather: Decodable {
    let information: [WeatherInfo]
    
    private enum CodingKeys: String, CodingKey {
        case information = "weather"
    }
    
    struct WeatherInfo: Decodable {
        let iconId: String
        let state: String
        
        private enum CodingKeys: String, CodingKey {
            case iconId = "icon"
            case state = "main"
        }
    }
}
