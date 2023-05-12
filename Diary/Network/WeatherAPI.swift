//
//  WeatherAPI.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/09.
//

import Foundation

enum WeatherAPI {
    case weatherInfo(latitude: Double, longitude: Double)
    case weatherImage(iconCode: String)
}

extension WeatherAPI {
    var baseURL: String {
        switch self {
        case .weatherInfo:
            return "https://api.openweathermap.org"
        case .weatherImage:
            return "https://openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .weatherInfo:
            return "/data/2.5/weather"
        case .weatherImage(let iconCode):
            return "/img/wn/\(iconCode)@2x.png"
        }
    }
    
    var queries: [String: String]? {
        switch self {
        case .weatherInfo(let latitude, let longitude):
            return ["appid": self.key, "lat": "\(latitude)", "lon": "\(longitude)"]
        case .weatherImage:
            return nil
        }
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
    
    func createURL() -> URL? {
        var urlComponents: URLComponents? = URLComponents(string: baseURL)
        
        urlComponents?.path = path
        if let queries {
            var queryItems: [URLQueryItem] = []
            
            queries.forEach { query in
                let queryItem = URLQueryItem(name: query.key, value: query.value)
                queryItems.append(queryItem)
            }
            
            urlComponents?.queryItems = queryItems
        }
        
        return urlComponents?.url
    }
    
    func createURLRequest() -> URLRequest? {
        guard let url = createURL() else {
            return nil
        }
        
        return URLRequest(url: url)
    }
}
