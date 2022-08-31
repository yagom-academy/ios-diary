//
//  WetherDecoder.swift
//  Diary
//
//  Created by 백곰, 주다 on 2022/08/31.
//

import Foundation

struct WeatherDecoder {
    func fetchWeather(data: Data) -> Weather? {
        let decoder = JSONDecoder()

        do {
            let weatherInformations = try decoder.decode(Weather.self, from: data)
            return weatherInformations
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
