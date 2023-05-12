//
//  Weather.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import Foundation

struct CurrentWeather: Decodable {
    let weather: [Weather]
}

final class Weather: Decodable, DataTransferObject {
    var main, icon: String?
    var id: UUID
    
    init(main: String? = nil, icon: String? = nil, id: UUID = UUID()) {
        self.main = main
        self.icon = icon
        self.id = id
    }
    
    init(weatherDAO: WeatherDAO) {
        self.main = weatherDAO.main
        self.icon = weatherDAO.icon
        self.id = weatherDAO.id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.main = try container.decodeIfPresent(String.self, forKey: .main)
        self.icon = try container.decodeIfPresent(String.self, forKey: .icon)
        self.id = UUID()
    }
    
    enum CodingKeys: CodingKey {
        case main
        case icon
        case id
    }
}
