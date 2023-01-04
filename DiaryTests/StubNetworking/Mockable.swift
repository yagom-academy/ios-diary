//
//  Mockable.swift
//  DiaryTests
//
//  Created by 이태영 on 2023/01/04.
//

import Foundation
@testable import Diary

protocol Mockable {
    static var mockData: Data? { get }
}

extension WeatherEntity: Mockable {
    static let mockData: Data? = """
    {
        "coord": {
            "lon": 126.98,
            "lat": 37.57
        },
        "weather": [
            {
                "id": 800,
                "main": "Clear",
                "description": "clear sky",
                "icon": "01n"
            }
        ],
        "base": "stations",
        "main": {
            "temp": 269.79,
            "feels_like": 269.79,
            "temp_min": 268.87,
            "temp_max": 270.99,
            "pressure": 1031,
            "humidity": 64
        },
        "visibility": 10000,
        "wind": {
            "speed": 1.03,
            "deg": 290
        },
        "clouds": {
            "all": 0
        },
        "dt": 1672833236,
        "sys": {
            "type": 1,
            "id": 8105,
            "country": "KR",
            "sunrise": 1672786028,
            "sunset": 1672820752
        },
        "timezone": 32400,
        "id": 1835848,
        "name": "Seoul",
        "cod": 200
    }
    """.data(using: .utf8)
}
