//
//  IconManager.swift
//  Diary
//
//  Created by SeoDongyeon on 2022/07/01.
//

import Foundation

struct IconManager {
    private let icon: String
    var currentWeatherIconImageURL: URL? {
        get {
            return OpenWeatherAPI.weatherIconImage(icon: icon).url
        }
    }
    
    init(icon: String) {
        self.icon = icon
    }
}
