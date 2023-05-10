//
//  Weather.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/09.
//

import Foundation

struct CurrentWeather: Codable {
    let weather: [Weather]
}

final class Weather: Codable, DataTransferObject {
    var main, icon: String?
    var id = UUID()
    
    init(weatherDAO: WeatherDAO) {
        self.main = weatherDAO.main
        self.icon = weatherDAO.icon
        self.id = weatherDAO.id
    }
    
    func updateContents(main: String, icon: String) {
        self.main = main
        self.icon = icon
    }
}
