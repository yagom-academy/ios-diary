//
//  WeatherDTO.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/30.
//

import Foundation

struct WeatherDTO: Decodable {
    let icon: [Icon]
    let description: DescriptionDTO
    
    struct Icon: Decodable {
        let icon: String
    }
    
    struct DescriptionDTO: Decodable {
        let temperature: Double
        let feelsLike: Double
        let minTemperature: Double
        let maxTempaerature: Double
        let pressure: Double
        let humidity: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case feelsLike = "feels_like"
            case minTemperature = "temp_min"
            case maxTempaerature = "temp_max"
            case pressure
            case humidity
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case icon = "weather"
        case description = "main"
    }
}
