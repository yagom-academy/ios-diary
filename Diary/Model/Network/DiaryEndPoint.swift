//
//  DiaryEndPoint.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/05/09.
//

import Foundation

enum DiaryEndPoint {
    case weather(lat: Double, lon: Double)
}

extension DiaryEndPoint {
    private var key: String {
        return "28513ae50dde03269224465c877e19ec"
    }
    
    var url: URL? {
        switch self {
        case .weather(let lat, let lon):
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(key)")
        }
    }
}
