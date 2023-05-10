//
//  WeatherAPI.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/09.
//

import Foundation

enum WeatherAPI {
    case weather
}

extension WeatherAPI: Requestable {
    var urlComponents: URLComponents? {
        var components = URLComponents(string: baseURL)
        components?.path = self.path
        
        var queriesItem: [URLQueryItem] = []
        self.queries.forEach { queryItem in
            let queryItem = URLQueryItem(name: queryItem.key, value: queryItem.value)
            queriesItem.append(queryItem)
        }
        
        components?.queryItems = queriesItem
        
        return components
    }
    
    var baseURL: String {
        return "https://api.openweathermap.org"
    }
    
    var path: String {
        switch self {
        case .weather:
            return "/data/2.5/weather"
        }
    }
    
    var queries: [String: String] {
        switch self {
        case .weather:
            return ["appid": self.key, "lat": "44.34", "lon": "10.99"]
        }
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var key: String {
//        get {
//          guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
//            fatalError("Info.plist를 찾지 못했습니다.")
//          }
//
//          let plist = NSDictionary(contentsOfFile: filePath)
//          guard let value = plist?.object(forKey: "API_KEY") as? String else {
//            fatalError("Info.plist에서 API_KEY를 찾을 수 없습니다.")
//          }
//
//          return value
//        }
        return "be61fea903194c94cb32f87980cbf5dc"
    }
    
    var headers: [String: String]? {
        return nil
    }
}
