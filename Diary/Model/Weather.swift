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
    var main, icon: String
    var id = UUID()
    
    func updateContents(main: String, icon: String) {
        self.main = main
        self.icon = icon
    }
}
