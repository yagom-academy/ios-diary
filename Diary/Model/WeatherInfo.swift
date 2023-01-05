//
//  WeatherInfo.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2023/01/03.
//

import Foundation

struct WeatherInfo: Hashable {
    let main: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case main, icon, weather
    }
}

extension WeatherInfo: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let nestedContainer = try weatherContainer.nestedContainer(keyedBy: CodingKeys.self)
        
        main = try nestedContainer.decode(String.self, forKey: .main)
        icon = try nestedContainer.decode(String.self, forKey: .icon)
    }
}

extension Weather {
    var weatherInfo: WeatherInfo? {
        guard let main = self.main,
              let icon = self.icon else {
            return nil
        }
        
        return WeatherInfo(main: main, icon: icon)
    }
}
