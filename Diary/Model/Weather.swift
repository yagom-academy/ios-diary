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
    var id: UUID = UUID()
    
    init(main: String? = nil, icon: String? = nil) {
        self.main = main
        self.icon = icon
    }
    
    init(weatherDAO: WeatherDAO) {
        self.main = weatherDAO.main
        self.icon = weatherDAO.icon
        self.id = weatherDAO.id
    }
    
    func updateContents(main: String?, icon: String?) {
        self.main = main
        self.icon = icon
    }
    
    enum CodingKeys: CodingKey {
        case main
        case icon
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.main = try container.decodeIfPresent(String.self, forKey: .main)
        self.icon = try container.decodeIfPresent(String.self, forKey: .icon)
    }
}
