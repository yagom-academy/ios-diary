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

class Weather: DataTransferObject, Codable {
    var main, icon: String
    var id = UUID()
    
    init(main: String, icon: String) {
        self.main = main
        self.icon = icon
    }
    
//    init(weatherDAO: DiaryDAO) {
//
//    }

    func updateContents(main: String, icon: String) {
        self.main = main
        self.icon = icon
    }
}
