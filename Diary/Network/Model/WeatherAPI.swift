//
//  WeatherAPI.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/14.
//

import Foundation

protocol URLalbe {
    var url: String? { get }
}

enum WeatherAPI: URLalbe {
    case weatherData(latitude: Double, longitude: Double)
    case weatherIcon(id: String)
    
    var url: String? {
        switch self {
        case .weatherData(latitude: let latitude, longitude: let longitude):
            guard let APIKey = WeatherAPI.APIKey else {
                return nil
            }
            
            return "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(APIKey)"
        case .weatherIcon(id: let id):
            return "https://openweathermap.org/img/wn/\(id).png"
        }
    }
    
    static var APIKey: String? {
        guard let file = Bundle.main.path(forResource: "WeatherInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY"] as? String else {
            fatalError("⛔️ API KEY를 가져오는데 실패하였습니다.")
        }
        
        return key
    }
}
