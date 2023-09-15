//
//  WeatherDecoder.swift
//  Diary
//
//  Created by 김민성 on 2023/09/14.
//

import Foundation

struct WeatherDecoder {
    static func decode(jsonData: Data) throws -> Weather? {
        do {
            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(WeatherData.self, from: jsonData)
            
            return weatherData.weather.first
        } catch {
            throw WeatherDecodingError.decodeFail
        }
    }
}
