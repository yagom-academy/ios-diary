//
//  ApiUrl.swift
//  WaetgerApi
//
//  Created by 우롱차, Red on 2022/06/28.
//

import UIKit

enum WeatherApi {
    
    // 원래 아래 APIKey는 커밋하고 싶지 않았는대 (보안 이슈 때문에) 커밋을 안하면 웨더가 실행을 못함으로 넣어줬습니다.
    private static let APIKey = "d3362243755c8f2545b6b103942b36d3"
    case weatherData(lat: Double, lon: Double)
    case image(icon: String)
    
    private var urlString: String {
        switch self {
        case .weatherData(let lat, let lon):
            return "https://api.openweathermap.org" +
            "/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(WeatherApi.APIKey)"
        case .image(let icon):
            return "https://openweathermap.org" + "/img/wn/\(icon).png"
        }
    }
    
    var url: URL? {
        let urlComponents = URLComponents(string: self.urlString)
        return urlComponents?.url
    }
    
    func makeRequest() throws -> URLRequest {
        
        guard let url = self.url else {
            throw(NetworkError.urlError)
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        return request
    }
}
