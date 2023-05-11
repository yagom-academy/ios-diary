//
//  Diary - URLRequestMaker.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import Foundation

struct URLRequestMaker {
    private let weatherAPIKey = "2e7f86fff79b58087d75569edba173a1"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
 
    func request(latitude: String, longitude: String) -> URLRequest? {
        var urlComponents = URLComponents(string: baseURL)
        let lattitude = URLQueryItem(name: "lat", value: lattitude)
        let longitude = URLQueryItem(name: "lon", value: longitude)
        let APIkey = URLQueryItem(name: "appid", value: weatherAPIKey)
        
        urlComponents?.queryItems = [lattitude, longitude, APIkey]
        
        guard let url = urlComponents?.url else { return nil }
        
        let request = URLRequest(url: url)

        return request
    }
}
