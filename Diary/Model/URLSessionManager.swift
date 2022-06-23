//
//  URLSessionGenerator.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/23.
//

import Foundation

enum EndPoint {
    private enum Constants {
        static let weatherInfoURL = "https://api.openweathermap.org/data/2.5/weather?"
        static let weatherIconURL = "https://openweathermap.org/img/wn/"
        static let appkey = "5d541eac3b64ce81f672025857e60683"
    }
    
    case weatherInfo(lat: Double, lon: Double)
    case weatherIcon(icon: String)
    
    var url: URL? {
        switch self {
        case .weatherInfo(let lat, let lon):
            return URL(string: "\(Constants.weatherInfoURL)lat=\(lat)&lon=\(lon)&APPID=\(Constants.appkey)")
        case .weatherIcon(let icon):
            return URL(string: "\(Constants.weatherIconURL)\(icon)@2x.png")
        }
    }
}

final class URLSessionManager {
    private let session: URLSession = URLSession.shared
    
    func request(endpoint: EndPoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = endpoint.url else {
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request, completionHandler: completion).resume()
    }
}
