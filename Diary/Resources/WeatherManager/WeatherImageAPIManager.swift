//
//  WeatherManager.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/27.
//

import Foundation

struct WeatherImageAPIManager: GETProtocol {
    var configuration: APIConfiguration
    var urlComponents: URLComponents
    
    init?(icon: String) {
        urlComponents = URLComponentsBuilder()
            .setScheme("https")
            .setHost("openweathermap.org")
            .setPath("/img/wn/\(icon)@4x.png")
            .build()
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        configuration = APIConfiguration(url: url)
    }
}
