//
//  CoordinateManager.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/07/01.
//

import Foundation

struct CoordinateManager {
    private let latitude: Double
    private let longitude: Double
    var currentCoordinationURL: URL? {
        get {
            return OpenWeatherAPI.weatherInformation(latitude: latitude, longitude: longitude).url
        }
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

