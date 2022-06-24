//
//  Weather.swift
//  Diary
//
//  Created by dudu, papri on 24/06/2022.
//

struct WeatherInfomation: Decodable {
    let weather: [Weather]
    
    struct Weather: Decodable {
        let main: String
        let icon: String
    }
}
