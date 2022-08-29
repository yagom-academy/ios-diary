//
//  WeatherDataAPIManager.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/29.
//

import Foundation

struct WeatherDataAPIManager: GETProtocol {
    var configuration: APIConfiguration
    var urlComponents: URLComponents
    
    init?(latitude: Double, longitude: Double) {
        urlComponents = URLComponentsBuilder()
            .setScheme("https")
            .setHost("api.openweathermap.org")
            .setPath("/data/2.5/weather")
            .addQuery(items: [WeatherURLQueryItem.latitude: "\(latitude)",
                              WeatherURLQueryItem.longitude: "\(longitude)",
                              WeatherURLQueryItem.apiKey: "16592fac87216b6b99b42948875396e6"])
            .build()
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        configuration = APIConfiguration(url: url)
    }
}
