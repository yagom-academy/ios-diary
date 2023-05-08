//
//  WeatherDTO.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/05/08.
//

struct WeatherDTO: Decodable {
    let weather: [Weather]
}

struct Weather: Decodable {
    let iconCode: String
    
    private enum CodingKeys: String, CodingKey {
        case iconCode = "icon"
    }
}
