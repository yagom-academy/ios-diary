//
//  CurrentWeather.swift
//  Diary
//
//  Created by Kyo, Baem on 2023/01/05.
//

struct CurrentWeather {
    var main: String?
    var iconID: String?
    
    init(iconID: String? = nil, main: String? = nil) {
        self.iconID = iconID
        self.main = main
    }
}
