//
//  WeatherAPI.swift
//  Diary
//
//  Created by hoon, karen on 2023/09/15.
//

enum WeatherAPI {}

extension WeatherAPI {
    struct Users: NetworkAPIDefinition {
        let urlInfo: URLInfo
        
        init(host: String, path: String, query: [String: String]? = nil) {
            self.urlInfo = .weatherAPI(host: host, path: path, query: query)
        }
    }
}
